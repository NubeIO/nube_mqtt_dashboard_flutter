import 'package:auto_route/auto_route.dart';

import '../../domain/session/session_repository_interface.dart';
import '../../injectable/injection.dart';
import '../../utils/logger/log.dart';

const _TAG = "ConfigGuard";

class ConfigGuard extends RouteGuard {
  final sessionRepository = getIt<ISessionRepository>();

  @override
  Future<bool> canNavigate(
    ExtendedNavigatorState navigator,
    String routeName,
    Object arguments,
  ) async {
    final result = await sessionRepository.getLoginStatus();
    final condition = result == ProfileStatusType.PROFILE_EXISTS;
    Log.i("canNavigate to $routeName $condition", tag: _TAG);
    return condition;
  }
}
