import 'package:dartz/dartz.dart';

import '../core/interfaces/repository.dart';
import 'failures.dart';

export 'failures.dart';

abstract class INotificationRepository implements IRepository {
  Future<Either<GetTokenFailure, String>> getToken();

  Stream<Either<TokenStreamFailure, String>> get tokenStream;
}
