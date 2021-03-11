import 'package:auto_route/auto_route.dart';

import '../../domain/configuration/configuration_repository_interface.dart';
import '../../injectable/injection.dart';
import '../../utils/logger/log.dart';

const _TAG = "ConfigGuard";

class ConfigGuard extends RouteGuard {
  final configRepository = getIt<IConfigurationRepository>();

  @override
  Future<bool> canNavigate(
    ExtendedNavigatorState navigator,
    String routeName,
    Object arguments,
  ) async {
    final result = await configRepository.getConfiguration();
    Log.i("canNavigate to $routeName ${result.isSome()}", tag: _TAG);
    return result.isSome();
  }
}
