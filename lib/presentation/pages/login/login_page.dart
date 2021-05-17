import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/login/login_cubit.dart';
import '../../../domain/forms/non_empty_validation.dart';
import '../../../domain/session/failures.dart';
import '../../../domain/session/session_data_source_interface.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/message_mixin.dart';
import '../../routes/router.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';
import '../../widgets/overlays/loading.dart';
import '../../widgets/responsive/padding.dart';

class LoginPage extends StatelessWidget with MessageMixin {
  final FocusScopeNode _node = FocusScopeNode();
  final bool isRegistrationStep;

  LoginPage({
    Key key,
    this.isRegistrationStep = true,
  }) : super(key: key);

  void _onLoginFailure(BuildContext context, LoginUserFailure failure) {
    onFailureMessage(
      context,
      failure.when(
        unexpected: () => I18n.of(context).failureGeneric,
        connection: () => I18n.of(context).failureConnection,
        invalidToken: () => "Something went wrong with generating a token.",
        server: () => I18n.of(context).failureServer,
        general: (message) => message,
      ),
    );
  }

  void _onLoginSuccess(
    BuildContext context,
    ProfileStatusType profileStatusType,
  ) {
    if (profileStatusType == ProfileStatusType.PROFILE_EXISTS) {
      ExtendedNavigator.of(context).pushConnectPage(isInitalConfig: true);
    } else if (profileStatusType == ProfileStatusType.NEEDS_VERIFICATION) {
      ExtendedNavigator.of(context).pushAndRemoveUntil(
        Routes.verificationPage,
        (route) => false,
      );
    }
  }

  Widget _formUsernameInput(BuildContext context) {
    return FormStringInput(
      validation: NonEmptyValidation(
        mapper: (failure) => failure.when(
          empty: () => "Username is required and can't be empty",
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
      validation: NonEmptyValidation(
        mapper: (failure) => failure.when(
          empty: () => "Password is required and can't be empty",
        ),
      ),
      obscureText: true,
      label: "Password",
      textInputAction: TextInputAction.done,
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
          success: (_) => fab,
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
            loading: () => overlay.showText("Logging In..."),
            failure: (failure) {
              overlay.hide();
              _onLoginFailure(context, failure);
            },
            success: (profileStatusType) {
              overlay.hide();
              _onLoginSuccess(context, profileStatusType);
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
