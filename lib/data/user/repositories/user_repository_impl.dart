import 'package:injectable/injectable.dart';

import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/notifications/notification_repository_interface.dart';
import '../../../domain/user/failures.dart';
import '../../../domain/user/user_data_source_interface.dart';
import '../../../domain/user/user_repository_interface.dart';

@LazySingleton(as: IUserRepository)
class UserRepositoryImpl extends IUserRepository {
  final IUserDataSource _userDataSource;
  final INotificationRepository _notificationRepository;
  UserRepositoryImpl(this._userDataSource, this._notificationRepository);

  @override
  Future<Either<GetUserFailure, UserModel>> getUser() {
    return futureFailureHelper(
      request: () async {
        final user = await _userDataSource.getUser();

        return Right(user);
      },
      failureMapper: (cases) => cases.maybeWhen(
        connection: () => const GetUserFailure.connection(),
        general: (message) => GetUserFailure.general(message),
        orElse: () => const GetUserFailure.server(),
      ),
    );
  }

  @override
  Future<Either<SetTokenFailure, String>> setDeviceToken() {
    return futureFailureHelper(
      request: () async {
        final tokenResult = await _notificationRepository.getToken();
        if (tokenResult.isLeft()) {
          return const Left(SetTokenFailure.unexpected());
        }
        final token = tokenResult.fold(
          (l) => throw AssertionError(),
          (token) => token,
        );
        await _userDataSource.setDeviceToken(token);
        return Right(token);
      },
      failureMapper: (cases) => cases.maybeWhen(
        connection: () => const SetTokenFailure.connection(),
        general: (message) => SetTokenFailure.general(message),
        orElse: () => const SetTokenFailure.server(),
      ),
    );
  }

  @override
  Future<Either<UserExistFailure, Unit>> checkEmail(String email) {
    return futureFailureHelper(
      request: () async {
        try {
          final exists = await _userDataSource.checkEmail(email);
          if (exists) {
            return const Left(UserExistFailure.userExists());
          } else {
            return const Right(unit);
          }
        } catch (e) {
          return const Left(UserExistFailure.unexpected());
        }
      },
      failureMapper: (cases) => cases.maybeWhen(
          connection: () => const UserExistFailure.connection(),
          orElse: () => const UserExistFailure.server()),
    );
  }

  @override
  Future<Either<UserExistFailure, Unit>> checkUsername(String username) {
    return futureFailureHelper(
      request: () async {
        try {
          final exists = await _userDataSource.checkUsername(username);
          if (exists) {
            return const Left(UserExistFailure.userExists());
          } else {
            return const Right(unit);
          }
        } catch (e) {
          return const Left(UserExistFailure.unexpected());
        }
      },
      failureMapper: (cases) => cases.maybeWhen(
          connection: () => const UserExistFailure.connection(),
          orElse: () => const UserExistFailure.server()),
    );
  }
}
