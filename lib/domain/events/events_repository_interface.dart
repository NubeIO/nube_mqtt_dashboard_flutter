import 'package:dartz/dartz.dart';

import 'entities.dart';

export 'package:dartz/dartz.dart';

export 'entities.dart';

abstract class IEventsRepository {
  Stream<GlobalEvents> get eventStream;

  Future<Unit> logout();
}
