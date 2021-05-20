import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/register/register_cubit.dart';
import '../../../domain/forms/email_validation.dart';
import '../../../domain/forms/username_validation.dart';
import '../../../generated/i18n.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';

class RegisterFormSecondPage extends StatelessWidget {
  const RegisterFormSecondPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode _node = FocusScopeNode();

    Widget _formUsernameInput(BuildContext context) {
      return FormStringInput(
        validation: UsernameValidation(
          mapper: (failure) => failure.when(
            usernameTaken: () => "Username you provided is already in use.",
            tooShort: () => "Username must be atleast 8 charecters long.",
            usernameInvalid: () => "Invalid username, try something else",
            unexpected: () => I18n.of(context).failureGeneric,
            connection: () => I18n.of(context).failureConnection,
            server: () => I18n.of(context).failureServer,
          ),
        ),
        label: "Username",
        initialValue: context.watch<RegisterCubit>().state.username,
        onChanged: context.watch<RegisterCubit>().setUsername,
        onEditingComplete: _node.nextFocus,
      );
    }

    Widget _formEmailInput(BuildContext context) {
      return FormStringInput(
        validation: EmailValidation(
          mapper: (failure) => failure.when(
            invalidEmail: () => "Please provide a valid email.",
            emailTaken: () => "Email you provided is already in use.",
            unexpected: () => I18n.of(context).failureGeneric,
            connection: () => I18n.of(context).failureConnection,
            server: () => I18n.of(context).failureServer,
          ),
        ),
        label: "Email",
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        initialValue: context.watch<RegisterCubit>().state.email,
        onChanged: context.watch<RegisterCubit>().setEmail,
      );
    }

    Widget _buildMainInputs(BuildContext context) {
      return Form(
        child: FocusScope(
          node: _node,
          child: Column(
            children: [
              _formUsernameInput(context),
              _formEmailInput(context),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormInfoWidget(
              title: "Register",
              subtitle: "Some additional info to verify its you.",
            ),
            _buildMainInputs(context)
          ],
        );
      },
    );
  }
}
