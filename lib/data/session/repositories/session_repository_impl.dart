import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/layout/layout_repository_interface.dart';
import '../../../domain/log/log_repository_interface.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../domain/network/api_data_source_interface.dart';
import '../../../domain/notifications/notification_repository_interface.dart';
import '../../../domain/session/session_data_source_interface.dart';
import '../../../domain/session/session_repository_interface.dart';
import '../../../domain/site/site_repository_interface.dart';
import '../../../domain/theme/theme_repository_interface.dart';
import '../../../domain/user/user_repository_interface.dart';
import '../../../utils/logger/log.dart';
import '../managers/pin_preference.dart';
import '../managers/session_preference.dart';

@LazySingleton(as: ISessionRepository)
class ProwdlySessionRepositoryImpl extends ISessionRepository {
  final PinPreferenceManager _pinPreferenceManager;
  final SessionPreferenceManager _sessionPreferenceManager;
  final ISessionDataSource _sessionDataSource;

  final IConfigurationRepository _configurationRepository;
  final ILayoutRepository _layoutRepository;
  final ILogRepository _logRepository;
  final IMqttRepository _mqttRepository;
  final IApiDataSource _networkRepository;
  final INotificationRepository _notificationRepository;
  final ISiteRepository _siteRepository;
  final IThemeRepository _themeRepository;
  final IUserRepository _userRepository;

  bool _hasValidated = false;

  final BehaviorSubject<ProfileStatusType> _profileTypeStream =
      BehaviorSubject();

  final BehaviorSubject<bool> _kioskModeStream = BehaviorSubject();

  @nullable
  StreamSubscription _subscription;

  ProwdlySessionRepositoryImpl(
    this._pinPreferenceManager,
    this._sessionPreferenceManager,
    this._sessionDataSource,
    this._configurationRepository,
    this._layoutRepository,
    this._logRepository,
    this._mqttRepository,
    this._networkRepository,
    this._notificationRepository,
    this._siteRepository,
    this._themeRepository,
    this._userRepository,
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
    _kioskModeStream.add(_pinPreferenceManager.isKioskMode);
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
  Future<bool> isKioskMode() async {
    return _pinPreferenceManager.isKioskMode;
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
  Future<Either<SetKioskFailure, Unit>> setKioskMode({
    bool isKioskMode = false,
  }) async {
    try {
      _pinPreferenceManager.isKioskMode = isKioskMode;
      _kioskModeStream.add(isKioskMode);
      return const Right(unit);
    } catch (e) {
      return const Left(SetKioskFailure.unexpected());
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
  Stream<bool> get kioskModeStream => _kioskModeStream.stream.distinct();

  @override
  Future<Option<String>> getPinConfiguration() async {
    if (_pinPreferenceManager.isPinSet) {
      return Some(_pinPreferenceManager.pin);
    }
    return const None();
  }

  Future<void> _onStartVerificationLooper() async {
    final isValidated = await validateUserProfile();
    if (!isValidated) {
      _notificationRepository.notificaitonStream.listen((event) async {
        if (event.isRight()) {
          final notificationData = event.getOrElse(
            () => throw AssertionError(),
          );

          notificationData.maybeWhen(
            verification: () async => validateUserProfile(),
            orElse: () {},
          );
        }
      });
    }
  }

  Future<bool> validateUserProfile() async {
    final userResult = await _userRepository.getUser();
    if (userResult.isLeft()) return false;
    final user = userResult.fold(
      (l) => throw AssertionError(),
      (user) => user,
    );
    if (user.state == UserVerificationState.VERIFIED) {
      _setProfileStatus(ProfileStatusType.PROFILE_EXISTS);
      return true;
    }
    return false;
  }

  Future<void> _fetchRequiredData() async {
    final configResult = await _configurationRepository.fetchConnectionConfig();
    await _siteRepository.fetchSites();
    if (configResult.isRight()) {
      final config = configResult.fold((l) => throw AssertionError(), id);
      await _mqttRepository.login(config);
    }
    await _configurationRepository.fetchTopicConfig();
  }

  Future<void> _onStopVerificationLooper() async {
    Log.i("Stopping Verification Listener");
    _subscription?.cancel();
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
  Future<Either<RefreshTokenFailure, Unit>> refreshToken() {
    return futureFailureHelper(
      request: () async {
        final jwtModel = await _sessionDataSource.refreshToken();
        _storeSession(jwtModel);

        return const Right(unit);
      },
      failureMapper: (cases) => cases.maybeWhen(
        refresh: () => const RefreshTokenFailure.refresh(),
        orElse: () => const RefreshTokenFailure.unexpected(),
      ),
    );
  }

  @override
  Future<Either<LogoutFailure, Unit>> logout({
    bool clearApi = true,
  }) async {
    try {
      if (clearApi) {
        final result = await _userRepository.removeDeviceToken();
        if (result.isLeft()) {
          final isValidError = result.fold(
            (failure) => failure.maybeWhen(
              invalidToken: () => false,
              orElse: () => true,
            ),
            (r) => true,
          );
          if (isValidError) {
            return result.fold(
              (failure) => Left(
                failure.when(
                  unexpected: () => const LogoutFailure.unexpected(),
                  connection: () => const LogoutFailure.connection(),
                  invalidToken: () => throw AssertionError(),
                  server: () => const LogoutFailure.server(),
                  general: (message) => LogoutFailure.general(message),
                ),
              ),
              (_) => throw AssertionError(),
            );
          }
        }
      }
      await _configurationRepository.clearData();
      await _layoutRepository.clearData();
      await _logRepository.clearData();
      await _mqttRepository.clearData();
      await _networkRepository.clearData();
      await _notificationRepository.clearData();
      await _siteRepository.clearData();
      await _themeRepository.clearData();

      await _pinPreferenceManager.clearData();
      await _sessionPreferenceManager.clearData();
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
