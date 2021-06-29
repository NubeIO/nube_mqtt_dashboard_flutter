import 'package:dartz/dartz.dart';

import '../../data/configuration/configuration_api.dart';
import '../../data/session/session_api.dart';
import '../../data/site/site_api.dart';
import '../../data/user/user_api.dart';
import '../core/interfaces/datasource.dart';

export '../../data/configuration/configuration_api.dart';
export '../../data/session/session_api.dart';
export '../../data/site/site_api.dart';
export '../../data/user/user_api.dart';
export '../core/interfaces/datasource.dart';

abstract class IApiDataSource implements IDataSource {
  Future<SessionApi> get sessionApi;

  Future<UserApi> get userApi;

  Future<ConfigurationApi> get configurationApi;

  Future<SiteApi> get siteApi;

  Future<Unit> clearData();
}
