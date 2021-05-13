import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../application/session/validate_pin/validate_pin_cubit.dart';
import '../../../domain/core/internal_state.dart';
import '../../../domain/session/failures.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../widgets/responsive/snackbar.dart';
import '../../widgets/screens/pin_screen.dart';

@FramyWidget(isPage: true)
class ValidatePinPage extends StatelessWidget {
  final cubit = getIt<ValidatePinCubit>();
  final String title;
  final String subtitle;

  ValidatePinPage({
    Key key,
    this.title = "Enter Pin Code",
    this.subtitle = "Please enter your pin so you can access the application. ",
  }) : super(key: key);

  void _navigateOnSuccess(BuildContext context, UserType type) {
    ExtendedNavigator.of(context).pop(type);
  }

  void _onValidateFailure(BuildContext context, ValidatePinFailure failure) {
    final snackbar = ResponsiveSnackbar.build(
      context,
      content: Text(
        failure.when(
          invalidPin: () => "Sorry the pin didn't match please try again. ",
          unexpected: () => I18n.of(context).failureGeneric,
        ),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).colorScheme.error),
      ),
      direction: Direction.left,
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void _onValidateState(
    BuildContext context,
    InternalStateValue<ValidatePinFailure, UserType> validateState,
  ) {
    validateState.maybeWhen(
        success: (type) {
          _navigateOnSuccess(context, type);
        },
        failure: (failure) {
          _onValidateFailure(context, failure);
        },
        orElse: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ValidatePinCubit>(
        create: (context) => cubit,
        child: BlocListener<ValidatePinCubit, ValidatePinState>(
          cubit: cubit,
          listener: (context, state) {
            _onValidateState(context, state.validateState);
          },
          child: PinScreen(
            title: title,
            subtitle: subtitle,
            onComplete: (value) => cubit.validatePin(value),
          ),
        ),
      ),
    );
  }
}
