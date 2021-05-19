import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/session/session_cubit.dart';
import '../../../injectable/injection.dart';
import '../../routes/router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  void _navigateToHomeScreen(BuildContext context) {
    ExtendedNavigator.of(context).pushAndRemoveUntil(
      Routes.dashboardPage,
      (route) => false,
    );
  }

  void _navigateToVerificatonScreen(BuildContext context) {
    ExtendedNavigator.of(context).pushAndRemoveUntil(
      Routes.verificationPage,
      (route) => false,
    );
  }

  void _navigateToOnboardingScreen(BuildContext context) {
    ExtendedNavigator.of(context).pushAndRemoveUntil(
      Routes.onBoardingPage,
      (route) => false,
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
          authenticated: () => _navigateToHomeScreen(context),
          validatePin: () => _navigateToEnterPinScreen(context),
          needsVerification: () => _navigateToVerificatonScreen(context),
          loggedOut: () => _navigateToOnboardingScreen(context),
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
