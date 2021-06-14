import 'package:dartz/dartz.dart';

import '../core/interfaces/data_repository.dart';
import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class INotificationRepository implements IDataRepository {
  Future<Either<GetTokenFailure, String>> getToken();

  Stream<Either<TokenStreamFailure, String>> get tokenStream;

  Stream<Either<AlertFailure, AlertEntity>> get alertStream;

  Stream<Either<NotificationFailure, NotificationData>> get notificaitonStream;
}
