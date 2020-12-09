import 'package:injectable/injectable.dart';

import '../../../domain/session/session_repository_interface.dart';
import '../managers/session_preference.dart';

@LazySingleton(as: ISessionRepository)
class ProwdlySessionRepositoryImpl extends ISessionRepository {
  final SessionPreferenceManager _sessionPreferenceManager;

  ProwdlySessionRepositoryImpl(this._sessionPreferenceManager);

  bool _hasValidated = false;

  @override
  Future<bool> hasValidated() async {
    return _hasValidated;
  }

  @override
  Future<SessionType> getSessionType() async {
    return _sessionPreferenceManager.status;
  }

  @override
  Future<Either<CreatePinFailure, Unit>> createPin(String pin) async {
    try {
      _sessionPreferenceManager.status = SessionType.REQUIRES_PIN;
      _sessionPreferenceManager.pin = pin;
      _hasValidated = true;
      return const Right(unit);
    } catch (e) {
      return const Left(CreatePinFailure.unexpected());
    }
  }

  @override
  Future<Either<ValidatePinFailure, Unit>> validatePin(String pin) async {
    if (_sessionPreferenceManager.pin == pin) {
      try {
        _sessionPreferenceManager.status = SessionType.REQUIRES_PIN;
        _hasValidated = true;
        return const Right(unit);
      } catch (e) {
        return const Left(ValidatePinFailure.unexpected());
      }
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
}
