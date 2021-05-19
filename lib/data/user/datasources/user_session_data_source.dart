import 'package:injectable/injectable.dart';

import '../../../data/network/dio_error_extension.dart';
import '../../../domain/network/api_data_source_interface.dart';
import '../../../domain/user/user_data_source_interface.dart';
import '../mapper/user_mapper.dart';

@LazySingleton(as: IUserDataSource)
class UserDataRepositoryImpl extends IUserDataSource {
  final IApiDataSource _apiRepository;

  final UserMapper sessionMapper = UserMapper();

  UserDataRepositoryImpl(this._apiRepository);

  @override
  Future<UserModel> getUser() {
    return _apiRepository.userApi
        .then((api) => api.getUser())
        .then((response) => sessionMapper.toUser(response))
        .catchDioException();
  }

  @override
  Future<Unit> setDeviceToken(String token) {
    return _apiRepository.userApi
        .then(
          (api) => api.setDeviceToken(SetDeviceTokenRequest(deviceId: token)),
        )
        .then((response) => unit)
        .catchDioException();
  }
}
