import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/notifications/notification_data_source_interface.dart';
import '../../../domain/notifications/notification_repository_interface.dart';

@LazySingleton(as: INotificationRepository)
class NotificationRepositoryImpl extends INotificationRepository {
  final INotificationDataSource _notificationDataSource;

  NotificationRepositoryImpl(this._notificationDataSource);

  @override
  Future<Either<GetTokenFailure, String>> getToken() async {
    try {
      final token = await _notificationDataSource.getToken();
      if (token.isNotEmpty) {
        return Right(token);
      }
      return const Left(GetTokenFailure.empty());
    } catch (e) {
      return const Left(GetTokenFailure.unexpected());
    }
  }

  @override
  Stream<Either<TokenStreamFailure, String>> get tokenStream async* {
    yield* _notificationDataSource.tokenStream
        .handleError((error) => const Left(TokenStreamFailure.unexpected()))
        .map((event) => Right(event));
  }
}
