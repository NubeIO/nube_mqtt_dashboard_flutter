import 'package:dartz/dartz.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';

abstract class IUserRepository {
  Future<Either<GetUserFailure, UserModel>> getUser();
}
