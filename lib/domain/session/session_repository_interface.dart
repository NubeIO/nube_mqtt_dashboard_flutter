import 'package:dartz/dartz.dart';

import '../core/interfaces/repository.dart';
import 'entities.dart';
import 'failures.dart';

export 'package:dartz/dartz.dart';

export 'entities.dart';
export 'failures.dart';

abstract class ISessionRepository implements IRepository {
  Future<bool> hasValidated();

  Future<bool> isPinProtected();

  Future<Option<String>> getPinConfiguration();

  Future<ProfileStatusType> getLoginStatus();

  Stream<ProfileStatusType> get loginStatusStream;

  Future<Either<CreatePinFailure, Unit>> createPin(String pin);

  Future<Either<ValidatePinFailure, Unit>> validatePin(String pin);

  Future<Either<CreateUserFailure, ProfileStatusType>> createUser(
    CreateUserEntity entity,
  );

  Future<Either<LoginUserFailure, ProfileStatusType>> loginUser(
    String username,
    String password,
  );

  Future<Either<LogoutFailure, Unit>> logout({bool clearApi = true});

  Future<String> get accessToken;

  Future<Either<RefreshTokenFailure, Unit>> refreshToken();
}
