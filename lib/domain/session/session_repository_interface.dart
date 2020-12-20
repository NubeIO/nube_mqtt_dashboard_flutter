import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'entities.dart';
import 'failures.dart';

export 'package:dartz/dartz.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ISessionRepository {
  Future<bool> hasValidated();

  Future<SessionType> getSessionType();

  Future<bool> isUserPinSet();

  Future<bool> isAdminPinSet();

  Future<Option<PinConfiguration>> getPinConfiguration();

  Future<Either<CreatePinFailure, Unit>> createPins({
    @required String adminPin,
    @required String userPin,
  });

  Future<Either<CreatePinFailure, Unit>> createUserPin(Option<String> pin);

  Future<Either<CreatePinFailure, Unit>> createAdminPin(String pin);

  Future<Either<ValidatePinFailure, UserType>> validatePin(String pin);

  Future<Either<LogoutFailure, Unit>> logout();
}
