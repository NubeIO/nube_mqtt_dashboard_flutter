import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../domain/session/session_data_source_interface.dart';
import '../../../domain/session/session_repository_interface.dart';
import '../../../domain/user/user_repository_interface.dart';
import '../../../utils/logger/log.dart';
import '../managers/pin_preference.dart';
import '../managers/session_preference.dart';

@LazySingleton(as: ISessionRepository)
class ProwdlySessionRepositoryImpl extends ISessionRepository {
  final PinPreferenceManager _pinPreferenceManager;
  final SessionPreferenceManager _sessionPreferenceManager;
  final IConfigurationRepository _configurationRepository;
  final IUserRepository _userRepository;
  final ISessionDataSource _sessionDataSource;
  final IMqttRepository _mqttRepository;

  bool _hasValidated = false;

  final BehaviorSubject<ProfileStatusType> _profileTypeStream =
      BehaviorSubject();

  @nullable
  Timer verificationTimer;

  ProwdlySessionRepositoryImpl(
    this._pinPreferenceManager,
    this._sessionPreferenceManager,
    this._sessionDataSource,
    this._userRepository,
    this._configurationRepository,
    this._mqttRepository,
  ) {
    _hasValidated = _pinPreferenceManager.isPinSet;
    loginStatusStream.listen((event) async {
      if (event == ProfileStatusType.NEEDS_VERIFICATION) {
        _onStartVerificationLooper();
      } else {
        _onStopVerificationLooper();
      }
      if (event == ProfileStatusType.PROFILE_EXISTS) {
        await _fetchRequiredData();
      }
    });
    _profileTypeStream.add(_sessionPreferenceManager.status);
  }

  @override
  Future<bool> hasValidated() async {
    return _hasValidated;
  }

  @override
  Future<bool> isPinProtected() async {
    return _pinPreferenceManager.isPinSet;
  }

  @override
  Future<Either<CreatePinFailure, Unit>> createPin(String pin) async {
    try {
      _pinPreferenceManager.pin = pin;
      return const Right(unit);
    } catch (e) {
      return const Left(CreatePinFailure.unexpected());
    }
  }

  @override
  Future<Either<ValidatePinFailure, Unit>> validatePin(String pin) async {
    try {
      if (_pinPreferenceManager.pin == pin) {
        _hasValidated = true;
        return const Right(unit);
      }
    } catch (e) {
      return const Left(ValidatePinFailure.unexpected());
    }

    return const Left(ValidatePinFailure.invalidPin());
  }

  @override
  Future<ProfileStatusType> getLoginStatus() async {
    return _sessionPreferenceManager.status;
  }

  @override
  Stream<ProfileStatusType> get loginStatusStream =>
      _profileTypeStream.stream.distinct();

  @override
  Future<Option<String>> getPinConfiguration() async {
    if (_pinPreferenceManager.isPinSet) {
      return Some(_pinPreferenceManager.pin);
    }
    return const None();
  }

  Future<void> _onStartVerificationLooper() async {
    Log.i("Starting Verification Loop");
    verificationTimer?.cancel();
    verificationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (value) async {
        final userResult = await _userRepository.getUser();
        if (userResult.isLeft()) return;
        final user = userResult.fold(
          (l) => throw AssertionError(),
          (user) => user,
        );
        if (user.state == UserVerificationState.VERIFIED) {
          _setProfileStatus(ProfileStatusType.PROFILE_EXISTS);
        }
      },
    );
  }

  Future<void> _fetchRequiredData() async {
    final configResult = await _configurationRepository.fetchConnectionConfig();
    if (configResult.isRight()) {
      final config = configResult.fold((l) => throw AssertionError(), id);
      await _mqttRepository.login(config);
    }
    await _configurationRepository.fetchTopicConfig();
  }

  Future<void> _onStopVerificationLooper() async {
    Log.i("Stopping Verification Loop");
    if (verificationTimer?.isActive == true) {
      verificationTimer?.cancel();
    }
  }

  @override
  Future<Either<CreateUserFailure, ProfileStatusType>> createUser(
    CreateUserEntity entity,
  ) async {
    return futureFailureHelper(
      request: () async {
        final jwtModel = await _sessionDataSource.createUser(
          firstName: entity.firstName,
          lastName: entity.lastName,
          email: entity.email,
          password: entity.password,
          username: entity.username,
        );

        _storeSession(jwtModel);

        final tokenResult = await _userRepository.setDeviceToken();
        Log.i(tokenResult.toString());

        if (tokenResult.isLeft()) {
          return tokenResult.fold(
            (failure) => Left(
              failure.when(
                unexpected: () => const CreateUserFailure.unexpected(),
                connection: () => const CreateUserFailure.connection(),
                invalidToken: () => const CreateUserFailure.invalidToken(),
                server: () => const CreateUserFailure.server(),
                general: (message) => CreateUserFailure.general(message),
              ),
            ),
            (_) => throw AssertionError(),
          );
        }
        _setProfileStatus(ProfileStatusType.NEEDS_VERIFICATION);

        return const Right(ProfileStatusType.NEEDS_VERIFICATION);
      },
      failureMapper: (cases) => cases.maybeWhen(
        connection: () => const CreateUserFailure.connection(),
        general: (message) => CreateUserFailure.general(message),
        orElse: () => const CreateUserFailure.server(),
      ),
    );
  }

  void _setProfileStatus(ProfileStatusType status) {
    _sessionPreferenceManager.status = status;
    _profileTypeStream.add(status);
  }

  @override
  Future<Either<LoginUserFailure, ProfileStatusType>> loginUser(
    String username,
    String password,
  ) async {
    return futureFailureHelper(
      request: () async {
        final jwtModel = await _sessionDataSource.loginUser(
          username: username,
          password: password,
        );
        _storeSession(jwtModel);

        final userResult = await _userRepository.getUser();

        if (userResult.isLeft()) {
          return userResult.fold(
            (failure) => Left(
              failure.when(
                unexpected: () => const LoginUserFailure.unexpected(),
                connection: () => const LoginUserFailure.connection(),
                invalidToken: () => const LoginUserFailure.invalidToken(),
                server: () => const LoginUserFailure.server(),
                general: (message) => LoginUserFailure.general(message),
              ),
            ),
            (_) => throw AssertionError(),
          );
        }
        final user = userResult.fold(
          (l) => throw AssertionError(),
          (user) => user,
        );

        final tokenResult = await _userRepository.setDeviceToken();

        Log.i(tokenResult.toString());

        if (tokenResult.isLeft()) {
          return tokenResult.fold(
            (failure) => Left(
              failure.when(
                unexpected: () => const LoginUserFailure.unexpected(),
                connection: () => const LoginUserFailure.connection(),
                invalidToken: () => const LoginUserFailure.invalidToken(),
                server: () => const LoginUserFailure.server(),
                general: (message) => LoginUserFailure.general(message),
              ),
            ),
            (_) => throw AssertionError(),
          );
        }

        if (user.state == UserVerificationState.UNVERIFIED) {
          _setProfileStatus(ProfileStatusType.NEEDS_VERIFICATION);
        } else {
          _setProfileStatus(ProfileStatusType.PROFILE_EXISTS);
        }
        return Right(_sessionPreferenceManager.status);
      },
      failureMapper: (cases) => cases.maybeWhen(
        connection: () => const LoginUserFailure.connection(),
        general: (message) => LoginUserFailure.general(message),
        orElse: () => const LoginUserFailure.server(),
      ),
    );
  }

  @override
  Future<Either<LogoutFailure, Unit>> logout() async {
    try {
      _pinPreferenceManager.clearData();
      _sessionPreferenceManager.clearData();
      return const Right(unit);
    } catch (e) {
      return const Left(LogoutFailure.unexpected());
    }
  }

  @override
  Future<String> get accessToken async => _sessionPreferenceManager.accessToken;

  void _storeSession(JwtModel jwt) {
    _sessionPreferenceManager.accessToken = jwt.accessToken;
    _sessionPreferenceManager.tokenType = jwt.tokenType;
  }
}
