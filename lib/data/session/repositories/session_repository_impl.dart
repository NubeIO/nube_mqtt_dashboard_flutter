import 'package:injectable/injectable.dart';

import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/session/session_data_source_interface.dart';
import '../../../domain/session/session_repository_interface.dart';
import '../managers/pin_preference.dart';
import '../managers/session_preference.dart';

@LazySingleton(as: ISessionRepository)
class ProwdlySessionRepositoryImpl extends ISessionRepository {
  final PinPreferenceManager _pinPreferenceManager;
  final SessionPreferenceManager _sessionPreferenceManager;
  final ISessionDataSource _sessionDataSource;
  bool _hasValidated = false;

  ProwdlySessionRepositoryImpl(
    this._pinPreferenceManager,
    this._sessionPreferenceManager,
    this._sessionDataSource,
  ) {
    _hasValidated = _pinPreferenceManager.isPinSet;
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
          deviceId: "",
        );
        _storeSession(jwtModel);

        _sessionPreferenceManager.status = ProfileStatusType.NEEDS_VERIFICATION;

        return const Right(ProfileStatusType.NEEDS_VERIFICATION);
      },
      failureMapper: (cases) => cases.maybeWhen(
        connection: () => const CreateUserFailure.connection(),
        general: (message) => CreateUserFailure.general(message),
        orElse: () => const CreateUserFailure.server(),
      ),
    );
  }

  @override
  Future<Either<LoginUserFailure, ProfileStatusType>> loginUser(
    String username,
    String password,
  ) async {
    return futureFailureHelper(
      request: () async {
        final jwtModel = await _sessionDataSource.loginUser(
          username,
          password,
          "",
        );
        _storeSession(jwtModel);
        // Get Validation Status

        _sessionPreferenceManager.status = ProfileStatusType.NEEDS_VERIFICATION;

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
