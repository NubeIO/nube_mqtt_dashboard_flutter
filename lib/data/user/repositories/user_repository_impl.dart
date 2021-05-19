import 'package:injectable/injectable.dart';

import '../../../domain/core/future_failure_helper.dart';
import '../../../domain/user/failures.dart';
import '../../../domain/user/user_data_source_interface.dart';
import '../../../domain/user/user_repository_interface.dart';

@LazySingleton(as: IUserRepository)
class UserRepositoryImpl extends IUserRepository {
  final IUserDataSource _userDataSource;
  UserRepositoryImpl(this._userDataSource);

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
}
