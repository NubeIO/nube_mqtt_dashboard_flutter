import 'package:auto_route/auto_route.dart';

import '../../domain/session/session_repository_interface.dart';
import '../../injectable/injection.dart';

class AuthGuard extends RouteGuard {
  final sessionRepository = getIt<ISessionRepository>();

  @override
  Future<bool> canNavigate(
    ExtendedNavigatorState navigator,
    String routeName,
    Object arguments,
  ) async {
    return sessionRepository.hasValidated();
  }
}
