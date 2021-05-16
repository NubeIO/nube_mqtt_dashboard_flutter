import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'failure.dart';

export 'failure.dart';

typedef ValidationMapper<T> = String Function(T value);

abstract class IValidation<T extends Failure, O> {
  final ValidationMapper<T> mapper;

  IValidation(this.mapper);

  Future<Either<Failure, O>> validate(String input);

  @nonVirtual
  String mapFailure(dynamic error) {
    return mapper(error as T);
  }
}
