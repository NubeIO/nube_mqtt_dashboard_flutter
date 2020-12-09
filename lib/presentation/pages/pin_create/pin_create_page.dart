import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../application/session/create_pin/create_pin_cubit.dart';
import '../../../domain/session/failures.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../routes/router.dart';
import '../../widgets/responsive/snackbar.dart';
import '../../widgets/screens/pin_screen.dart';

@FramyWidget(isPage: true)
class CreatePinPage extends StatelessWidget {
  final cubit = getIt<CreatePinCubit>();

  CreatePinPage({Key key}) : super(key: key);

  void _navigateToConnectScreen(BuildContext context) {
    ExtendedNavigator.of(context)
        .pushAndRemoveUntil(Routes.connectPage, (route) => false);
  }

  void _onCreatePinFailure(BuildContext context, CreatePinFailure failure) {
    final snackbar = ResponsiveSnackbar.build(
      context,
      content: Text(
        failure.when(
          unexpected: () => I18n.of(context).failureGeneric,
        ),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).errorColor),
      ),
      direction: Direction.left,
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CreatePinCubit>(
        create: (context) => cubit,
        child: BlocListener<CreatePinCubit, CreatePinState>(
          cubit: cubit,
          listener: (context, state) {
            state.state.maybeWhen(
                success: () {
                  _navigateToConnectScreen(context);
                },
                failure: (failure) {
                  _onCreatePinFailure(context, failure);
                },
                orElse: () {});
          },
          child: PinScreen(
            title: "Enter Pin Code",
            subtitle:
                "Please create a pin which will be used to lock down the application. ",
            onComplete: cubit.createPin,
          ),
        ),
      ),
    );
  }
}
