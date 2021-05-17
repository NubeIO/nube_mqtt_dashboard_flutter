import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/notifications/notification_repository_interface.dart';
import '../../../domain/session/session_data_source_interface.dart';
import '../../../domain/session/session_repository_interface.dart';
import '../managers/pin_preference.dart';
import '../managers/session_preference.dart';

@LazySingleton(as: ISessionRepository)
class ProwdlySessionRepositoryImpl extends ISessionRepository {
  final PinPreferenceManager _pinPreferenceManager;
  final SessionPreferenceManager _sessionPreferenceManager;
  final INotificationRepository _notificationRepository;
  final ISessionDataSource _sessionDataSource;
  bool _hasValidated = false;

  final BehaviorSubject<ProfileStatusType> _profileTypeStream =
      BehaviorSubject();

  ProwdlySessionRepositoryImpl(
    this._pinPreferenceManager,
    this._sessionPreferenceManager,
    this._notificationRepository,
    this._sessionDataSource,
  ) {
    _hasValidated = _pinPreferenceManager.isPinSet;
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
  Stream<ProfileStatusType> get loginStatusStream => _profileTypeStream.stream;

  @override
  Future<Either<CreateUserFailure, ProfileStatusType>> createUser(
    CreateUserEntity entity,
  ) async {
    return futureFailureHelper(
      request: () async {
        final tokenId = await _notificationRepository.getToken();

        if (tokenId.isLeft()) {
          return const Left(CreateUserFailure.invalidToken());
        }

        final deviceId = tokenId.fold(
          (_) => throw AssertionError(),
          (deviceId) => deviceId,
        );

        final jwtModel = await _sessionDataSource.createUser(
          firstName: entity.firstName,
          lastName: entity.lastName,
          email: entity.email,
          password: entity.password,
          username: entity.username,
          deviceId: deviceId,
        );
        _storeSession(jwtModel);

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
        final tokenId = await _notificationRepository.getToken();

        if (tokenId.isLeft()) {
          return const Left(LoginUserFailure.invalidToken());
        }

        final deviceId = tokenId.fold(
          (_) => throw AssertionError(),
          (deviceId) => deviceId,
        );

        final jwtModel = await _sessionDataSource.loginUser(
          username: username,
          password: password,
          deviceId: deviceId,
        );
        _storeSession(jwtModel);
        // Get Validation Status

        _setProfileStatus(ProfileStatusType.NEEDS_VERIFICATION);

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

  void _storeSession(JwtModel jwt) {
    _sessionPreferenceManager.refreshToken = jwt.refreshToken;
    _sessionPreferenceManager.token = jwt.jwt;
    _sessionPreferenceManager.idToken = jwt.idToken;
  }
}
