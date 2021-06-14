import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/session/validate_pin/validate_pin_cubit.dart';
import '../../../domain/core/internal_state.dart';
import '../../../domain/session/failures.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/message_mixin.dart';
import '../../widgets/screens/pin_screen.dart';

class ValidatePinPage extends StatelessWidget with MessageMixin {
  final cubit = getIt<ValidatePinCubit>();
  final String title;
  final String subtitle;

  ValidatePinPage({
    Key key,
    this.title = "Enter Pin Code",
    this.subtitle = "Please enter your pin so you can access the application. ",
  }) : super(key: key);

  void _navigateOnSuccess(BuildContext context, Unit type) {
    ExtendedNavigator.of(context).pop(type);
  }

  void _onValidateFailure(BuildContext context, ValidatePinFailure failure) {
    onFailureMessage(
      context,
      failure.when(
        invalidPin: () => "Sorry the pin didn't match please try again. ",
        unexpected: () => I18n.of(context).failureGeneric,
      ),
    );
  }

  void _onValidateState(
    BuildContext context,
    InternalStateValue<ValidatePinFailure, Unit> validateState,
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
