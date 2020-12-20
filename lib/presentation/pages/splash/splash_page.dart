import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/session/session_cubit.dart';
import '../../../injectable/injection.dart';
import '../../routes/router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  void _navigateToHomeScreen(BuildContext context) {
    ExtendedNavigator.of(context)
        .pushAndRemoveUntil(Routes.dashboardPage, (route) => false);
  }

  void _navigateToConnectScreen(BuildContext context) {
    ExtendedNavigator.of(context).pushAndRemoveUntil(
      Routes.connectPage,
      (route) => false,
      arguments: ConnectPageArguments(isInitalConfig: true),
    );
  }

  Future<void> _navigateToEnterPinScreen(BuildContext context) async {
    final result = await ExtendedNavigator.of(context).pushValidatePinPage();

    if (result == null) {
      ExtendedNavigator.of(context).pop();
    } else {
      _navigateToHomeScreen(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      cubit: getIt<SessionCubit>(),
      listener: (_, state) {
        state.when(
          initial: () {},
          createConfig: () => _navigateToConnectScreen(context),
          validatePin: () => _navigateToEnterPinScreen(context),
          authenticated: () => _navigateToHomeScreen(context),
        );
      },
      builder: (context, state) => const _SplashWidget(),
    );
  }
}

class _SplashWidget extends StatelessWidget {
  const _SplashWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
