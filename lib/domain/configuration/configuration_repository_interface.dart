import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class IConfigurationRepository {
  Future<Option<Configuration>> getConfiguration();

  Future<Either<SaveFailure, bool>> save({
    @required String host,
    @required int port,
    @required String clientId,
    @required String username,
    @required String password,
    @required String layoutTopic,
  });
}
