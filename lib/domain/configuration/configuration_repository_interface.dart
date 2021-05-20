import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/interfaces/repository.dart';
import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class IConfigurationRepository implements IRepository {
  Stream<Configuration> get configurationStream;

  Stream<String> get layoutTopicStream;

  Stream<String> get alertTopicStream;

  Future<Either<GetConnectionFailure, Configuration>> fetchConnectionConfig();

  Future<Either<GetTopicFailure, TopicConfiguration>> fetchTopicConfig();

  Future<Either<SaveFailure, Unit>> save({
    @required String host,
    @required int port,
    @required String clientId,
    @required String username,
    @required String password,
  });

  Future<Either<SaveFailure, Unit>> saveTopics({
    @required String layoutTopic,
    @required String alertTopic,
  });
}
