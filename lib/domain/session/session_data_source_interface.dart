import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'entities.dart';

export 'package:dartz/dartz.dart';

export 'entities.dart';

abstract class ISessionDataSource {
  Future<JwtModel> createUser({
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String password,
    @required String username,
    @required String deviceId,
  });

  Future<JwtModel> loginUser(
    String username,
    String password,
    String deviceId,
  );

  Future<Unit> logout();
}
