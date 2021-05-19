import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../core/interfaces/datasource.dart';
import 'entities.dart';

export 'package:dartz/dartz.dart';

export 'entities.dart';

abstract class ISessionDataSource implements IDataSource {
  Future<JwtModel> createUser({
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String password,
    @required String username,
  });

  Future<JwtModel> loginUser({
    @required String username,
    @required String password,
  });

  Future<Unit> logout();
}
