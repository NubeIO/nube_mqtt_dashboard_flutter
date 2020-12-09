import 'package:dartz/dartz.dart';

import 'entities.dart';
import 'failures.dart';

export 'package:dartz/dartz.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ISessionRepository {
  Future<bool> hasValidated();

  Future<SessionType> getSessionType();

  Future<Either<CreatePinFailure, Unit>> createPin(String pin);

  Future<Either<ValidatePinFailure, Unit>> validatePin(String pin);

  Future<Either<LogoutFailure, Unit>> logout();
}
