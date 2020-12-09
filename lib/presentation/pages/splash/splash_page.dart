import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/session/session_cubit.dart';
import '../../../injectable/injection.dart';
import '../../routes/router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  void _navigateToConnectScreen(BuildContext context) {
    ExtendedNavigator.of(context)
        .pushAndRemoveUntil(Routes.connectPage, (route) => false);
  }

  void _navigateToEnterPinScreen(BuildContext context) {
    ExtendedNavigator.of(context)
        .pushAndRemoveUntil(Routes.validatePinPage, (route) => false);
  }

  void _navigateToCreatePinScreen(BuildContext context) {
    ExtendedNavigator.of(context)
        .pushAndRemoveUntil(Routes.createPinPage, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      cubit: getIt<SessionCubit>(),
      listener: (context, state) {
        state.when(
          initial: () {},
          createPin: () => _navigateToCreatePinScreen(context),
          validatePin: () => _navigateToEnterPinScreen(context),
          authenticated: () => _navigateToConnectScreen(context),
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
