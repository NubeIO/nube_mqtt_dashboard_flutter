import 'package:dartz/dartz.dart';

import '../core/interfaces/datasource.dart';
import 'entities.dart';

export 'package:dartz/dartz.dart';

export 'entities.dart';

abstract class IUserDataSource implements IDataSource {
  Future<UserModel> getUser();

  Future<Unit> setDeviceToken(String token);

  Future<bool> checkEmail(String email);

  Future<bool> checkUsername(String username);

  Future<Unit> removeDeviceToken(String token);
}
