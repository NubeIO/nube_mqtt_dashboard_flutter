import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class IConfigurationRepository {
  Future<Option<Configuration>> getConfiguration();

  Future<Either<SaveAndConnectFailure, Unit>> connect({
    @required String host,
    @required int port,
    @required String clientId,
    @required String username,
    @required String password,
  });
}
