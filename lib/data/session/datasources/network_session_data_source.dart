import 'package:injectable/injectable.dart';

import '../../../data/network/dio_error_extension.dart';
import '../../../domain/network/api_data_source_interface.dart';
import '../../../domain/session/session_data_source_interface.dart';
import '../mappers/session.dart';
import '../session_api.dart';

@LazySingleton(as: ISessionDataSource)
class SessionDataRepositoryImpl extends ISessionDataSource {
  final IApiDataSource _apiRepository;

  final SessionMapper sessionMapper = SessionMapper();

  SessionDataRepositoryImpl(this._apiRepository);

  @override
  Future<JwtModel> createUser({
    String firstName,
    String lastName,
    String email,
    String password,
    String username,
    String deviceId,
  }) {
    return _apiRepository.sessionApi
        .then((api) => api.registerUser(RegisterRequest(
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: password,
              username: username,
            )))
        .then((response) => sessionMapper.toJwt(response))
        .catchDioException();
  }

  @override
  Future<JwtModel> loginUser({
    String username,
    String password,
  }) {
    return _apiRepository.sessionApi
        .then((api) => api.loginUser(LoginRequest(
              username: username,
              password: password,
            )))
        .then((response) => sessionMapper.toJwt(response))
        .catchDioException();
  }

  @override
  Future<Unit> logout() {
    return _apiRepository.sessionApi
        .then((api) => api.logout())
        .then((value) => unit)
        .catchDioException();
  }
}
