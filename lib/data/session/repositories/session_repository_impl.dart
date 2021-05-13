import 'package:injectable/injectable.dart';

import '../../../domain/session/session_repository_interface.dart';
import '../managers/session_preference.dart';

@LazySingleton(as: ISessionRepository)
class ProwdlySessionRepositoryImpl extends ISessionRepository {
  final SessionPreferenceManager _sessionPreferenceManager;

  bool _hasValidated = false;

  ProwdlySessionRepositoryImpl(this._sessionPreferenceManager) {
    _hasValidated = _sessionPreferenceManager.isPinSet;
  }

  @override
  Future<bool> hasValidated() async {
    return _hasValidated;
  }

  @override
  Future<bool> isPinProtected() async {
    return _sessionPreferenceManager.isPinSet;
  }

  @override
  Future<Either<CreatePinFailure, Unit>> createPin(String pin) async {
    try {
      _sessionPreferenceManager.pin = pin;
      return const Right(unit);
    } catch (e) {
      return const Left(CreatePinFailure.unexpected());
    }
  }

  @override
  Future<Either<ValidatePinFailure, Unit>> validatePin(String pin) async {
    try {
      if (_sessionPreferenceManager.pin == pin) {
        _hasValidated = true;
        return const Right(unit);
      }
    } catch (e) {
      return const Left(ValidatePinFailure.unexpected());
    }

    return const Left(ValidatePinFailure.invalidPin());
  }

  @override
  Future<Either<LogoutFailure, Unit>> logout() async {
    try {
      _sessionPreferenceManager.clearData();
      return const Right(unit);
    } catch (e) {
      return const Left(LogoutFailure.unexpected());
    }
  }

  @override
  Future<Either<CreateUserFailure, Unit>> createUser(CreateUserEntity entity) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<ProfileStatusType> getLoginStatus() {
    // TODO: implement getLoginStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<LoginUserFailure, Unit>> loginUser(
      String email, String password) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }
}
