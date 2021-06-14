import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/configuration/configuration_cubit.dart';
import '../../../domain/session/failures.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/alert_mixin.dart';
import '../../mixins/loading_mixin.dart';
import '../../mixins/message_mixin.dart';
import '../../routes/router.dart';
import '../../themes/nube_theme.dart';
import '../../themes/theme_interface.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';
import '../../widgets/form_elements/styles/input_types.dart';
import '../../widgets/form_elements/theme_input.dart';
import '../../widgets/responsive/master_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/responsive/screen_type_layout.dart';

class ConnectPage extends StatefulWidget {
  final bool isInitalConfig;
  const ConnectPage({
    Key key,
    this.isInitalConfig = false,
  }) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage>
    with MessageMixin, LoadingMixin, AlertMixin {
  ConfigurationCubit cubit;
  final FocusScopeNode _node = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    cubit = getIt<ConfigurationCubit>();
  }

  void _onSaveFailure(
    BuildContext context,
    CreatePinFailure failure,
  ) {
    onFailureMessage(
      context,
      failure.when(
        unexpected: () => I18n.of(context).failureGeneric,
      ),
    );
  }

  void _onLogoutFailure(
    BuildContext context,
    LogoutFailure failure,
  ) {
    onFailureMessage(
      context,
      failure.when(
        unexpected: () => I18n.of(context).failureGeneric,
        connection: () => I18n.of(context).failureConnection,
        server: () => I18n.of(context).failureServer,
        general: (message) => message,
      ),
    );
  }

  void _onLogoutSuccess(BuildContext context) {
    _navigateToSplashScreen(context);
  }

  void _navigateToDashboardScreen(BuildContext context) {
    ExtendedNavigator.of(context).pushAndRemoveUntil(
      Routes.dashboardPage,
      (route) => false,
    );
  }

  void _navigateToSplashScreen(BuildContext context) {
    ExtendedNavigator.of(context).pushAndRemoveUntil(
      Routes.splashPage,
      (route) => false,
    );
  }

  void _onNavigateChangeTheme(BuildContext context) {
    ExtendedNavigator.of(context).pushPreviewPage();
  }

  Future<String> _onGetPin(BuildContext context) async {
    final result = await ExtendedNavigator.of(context).pushCreatePinPage(
      subtitle:
          "Please enter a user pin which will be used to lock down the application for users.",
    );
    return result;
  }

  void _showLogoutPrompt(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    showPromptAlert(
      context,
      title: "Logout",
      subtitle: "Are you sure you want to log out?",
      actionText: "Logout",
      color: color,
      onAction: cubit.logout,
    );
  }

  Widget _buildLayout(BuildContext context) {
    return BuildForm(
        child: FocusScope(
      node: _node,
      child: Column(
        children: [
          _themeInput(context),
          const SizedBox(height: 16),
          _buildPin(context),
        ],
      ),
    ));
  }

  Widget _themeInput(BuildContext context) {
    return ThemeInput(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.padding(
          context,
          size: PaddingSize.medium,
        ),
        vertical: 16,
      ),
      currentTheme: context.select<ConfigurationCubit, ITheme>(
        (cubit) => NubeTheme.map(cubit.state.currentTheme),
      ),
      onTap: () => _onNavigateChangeTheme(context),
    );
  }

  Widget _buildPin(BuildContext context) {
    return FormPinInput(
      label: "Access Pin",
      getPin: () => _onGetPin(context),
      initialValue: cubit.state.accessPin,
      onChanged: cubit.setPin,
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToDashboardScreen(context),
      label: const Text("Next"),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final isInitalConfig = widget.isInitalConfig;
    final errorColor = Theme.of(context).errorColor;
    final minWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormInfoWidget(
                  title:
                      isInitalConfig ? "Configuration" : "Change Configuration",
                  subtitle: "Your personal theme and security settings.",
                ),
                _buildLayout(context)
              ],
            ),
          ),
          if (!isInitalConfig)
            FlatButton(
              minWidth: minWidth,
              height: 48,
              onPressed: () => _showLogoutPrompt(context),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Logout",
                  textAlign: TextAlign.left,
                  style: InputStyles.textStyle(context)
                      .copyWith(color: errorColor),
                ),
              ),
            )
          else
            const SizedBox(),
          SizedBox(
            height: ResponsiveSize.padding(context),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          isInitalConfig ? _buildFab(context) : const SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => cubit,
        child: BlocConsumer<ConfigurationCubit, ConfigurationState>(
          cubit: cubit,
          listener: (context, state) {
            state.saveState.maybeWhen(
              loading: () => showLoading(context, message: "Saving..."),
              failure: (failure) {
                hideLoading(context);
                _onSaveFailure(context, failure);
              },
              success: () {
                hideLoading(context);
              },
              orElse: () => hideLoading(context),
            );

            state.logoutState.maybeWhen(
              loading: () => showLoading(context, message: "Logging Out..."),
              failure: (failure) {
                hideLoading(context);
                _onLogoutFailure(context, failure);
              },
              success: () {
                hideLoading(context);
                _onLogoutSuccess(context);
              },
              orElse: () => hideLoading(context),
            );
          },
          builder: (context, state) {
            if (!state.dataReady) {
              return Container();
            }
            return ScreenTypeLayout(
              mobile: _buildScaffold(context),
              tablet: MasterLayout(
                master: _buildScaffold(context),
              ),
            );
          },
        ),
      ),
    );
  }
}
