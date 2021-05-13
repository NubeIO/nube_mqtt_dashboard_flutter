import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../data/network/exceptions.dart';
import '../../data/network/network_failure_cases.dart';
import 'failure.dart';

Future<Either<F, Response>> futureFailureHelper<F extends Failure, Response>({
  @required Future<Either<F, Response>> Function() request,
  @required F Function(NetworkFailureCase cases) failureMapper,
}) async {
  try {
    return await request();
  } on NetworkException catch (e) {
    return Left(failureMapper(e.asFailure));
  } catch (e) {
    return Left(failureMapper(const NetworkFailureCase.unexpected()));
  }
}
