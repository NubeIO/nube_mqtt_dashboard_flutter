import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/login/login_cubit.dart';
import '../../../domain/forms/password_validation.dart';
import '../../../domain/forms/username_validation.dart';
import '../../../domain/session/failures.dart';
import '../../../injectable/injection.dart';
import '../../routes/router.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';
import '../../widgets/overlays/loading.dart';
import '../../widgets/responsive/padding.dart';

class LoginPage extends StatelessWidget {
  final FocusScopeNode _node = FocusScopeNode();
  final bool isRegistrationStep;

  LoginPage({
    Key key,
    this.isRegistrationStep = true,
  }) : super(key: key);

  void _onLoginFailure(BuildContext context, LoginUserFailure failure) {}

  void _onLoginSuccess(BuildContext context) {
    ExtendedNavigator.of(context).pushConnectPage(isInitalConfig: true);
  }

  Widget _formUsernameInput(BuildContext context) {
    return FormStringInput(
      validation: UsernameValidation(
        mapper: (failure) => failure.when(
          usernameTaken: () => "",
          usernameInvalid: () => "",
        ),
      ),
      label: "Username",
      initialValue: context.watch<LoginCubit>().state.username,
      onChanged: context.watch<LoginCubit>().setUsername,
      onEditingComplete: _node.nextFocus,
    );
  }

  Widget _formPasswordInput(BuildContext context) {
    return FormStringInput(
      validation: PasswordValidation(
        mapper: (failure) => failure.when(
          tooShort: () => "",
          passwordMismatch: () => "",
        ),
      ),
      obscureText: true,
      label: "Password",
      initialValue: context.watch<LoginCubit>().state.password,
      onChanged: context.watch<LoginCubit>().setPassword,
    );
  }

  Widget _buildFab(BuildContext context) {
    final cubit = context.watch<LoginCubit>();

    final fab = FloatingActionButton.extended(
      onPressed: cubit.login,
      label: const Text("Login"),
    );

    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      if (cubit.isValid) {
        return state.loginState.maybeWhen(
          initial: () => fab,
          success: () => fab,
          orElse: () => Container(),
        );
      }
      return Container();
    });
  }

  Widget _buildMainInputs(BuildContext context) {
    return Form(
      child: FocusScope(
        node: _node,
        child: Column(
          children: [
            _formUsernameInput(context),
            _formPasswordInput(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final overlay = LoadingOverlay.of(context);

    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          state.loginState.maybeWhen(
            loading: () => overlay.showText("Connecting..."),
            failure: (failure) {
              overlay.hide();
              _onLoginFailure(context, failure);
            },
            success: () {
              overlay.hide();
              _onLoginSuccess(context);
            },
            orElse: () => overlay.hide(),
          );
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
            ),
            body: Column(
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
                    "Welcome Back",
                    style: textTheme.headline1,
                  ),
                ),
                FormPadding(
                  child: Text(
                    "Sign in to continue.",
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
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: _buildFab(context),
          );
        },
      ),
    );
  }
}
