import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nube_mqtt_dashboard/domain/forms/password_validation.dart';

import '../../../application/register/register_cubit.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';
import '../../widgets/responsive/padding.dart';

class RegisterFormLastPage extends StatelessWidget {
  const RegisterFormLastPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final FocusScopeNode _node = FocusScopeNode();

    Widget _formPasswordInput(BuildContext context) {
      return FormStringInput(
        validation: PasswordValidation(
          mapper: (failure) => failure.when(
            tooShort: () => "Password must be atleast 8 charecters long.",
            noDigit: () => "Password must have at least one digit (0-9).",
            noUpperChar: () =>
                "Password must have at least one uppercase (A-Z).",
            passwordMismatch: () => "Opps, seems the passwords don't match.",
          ),
        ),
        label: "Password",
        obscureText: true,
        initialValue: context.watch<RegisterCubit>().state.password,
        onChanged: context.watch<RegisterCubit>().setPassword,
        onEditingComplete: _node.nextFocus,
      );
    }

    Widget _formConfirmPasswordInput(BuildContext context) {
      return FormStringInput(
        validation: PasswordValidation(
          mapper: (failure) => failure.when(
            tooShort: () => "Password must be atleast 8 charecters long.",
            noDigit: () => "Password must have at least one digit (0-9).",
            noUpperChar: () =>
                "Password must have at least one uppercase (A-Z).",
            passwordMismatch: () => "Opps, seems the passwords don't match.",
          ),
          previousPassword: () => context.read<RegisterCubit>().state.password,
        ),
        label: "Confirm Password",
        obscureText: true,
        textInputAction: TextInputAction.done,
        initialValue: context.watch<RegisterCubit>().state.confirmPassword,
        onChanged: context.watch<RegisterCubit>().setConfirmPassword,
      );
    }

    Widget _buildMainInputs(BuildContext context) {
      return Form(
        child: FocusScope(
          node: _node,
          child: Column(
            children: [
              _formPasswordInput(context),
              _formConfirmPasswordInput(context),
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
            SizedBox(
              height: ResponsiveSize.padding(
                context,
                size: PaddingSize.small,
              ),
            ),
            FormPadding(
              child: Text(
                "Register",
                style: textTheme.headline1,
              ),
            ),
            FormPadding(
              child: Text(
                "Secure your account with a strong password.",
                style: textTheme.bodyText1,
              ),
            ),
            SizedBox(
              height: ResponsiveSize.padding(
                context,
                size: PaddingSize.large,
              ),
            ),
            _buildMainInputs(context)
          ],
        );
      },
    );
  }
}
