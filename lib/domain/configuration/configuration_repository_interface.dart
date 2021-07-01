import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../core/interfaces/data_repository.dart';
import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class IConfigurationRepository implements IDataRepository {
  Stream<Configuration> get configurationStream;

  Stream<String> get layoutTopicStream;

  Stream<KtList<SiteAlert>> get alertTopicStream;

  Future<Either<GetConnectionFailure, Configuration>> fetchConnectionConfig();

  Future<Either<GetTopicFailure, TopicConfiguration>> fetchTopicConfig();

  Future<Either<SaveFailure, Unit>> save({
    @required String host,
    @required int port,
    @required String clientId,
    @required String username,
    @required String password,
  });
}
