import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../application/configuration/configuration_cubit.dart';
import '../../../domain/forms/layout_topic_validation.dart';
import '../../../domain/forms/non_empty_validation.dart';
import '../../../domain/forms/port_validation.dart';
import '../../../domain/forms/url_validation.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/message_mixin.dart';
import '../../routes/router.dart';
import '../../themes/nube_theme.dart';
import '../../themes/theme_interface.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';
import '../../widgets/form_elements/theme_input.dart';
import '../../widgets/overlays/loading.dart';
import '../../widgets/responsive/master_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/responsive/screen_type_layout.dart';

@FramyWidget(isPage: true)
class ConnectPage extends StatefulWidget {
  final bool isInitalConfig;
  const ConnectPage({
    Key key,
    this.isInitalConfig = false,
  }) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> with MessageMixin {
  ConfigurationCubit cubit;
  final FocusScopeNode _node = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    cubit = getIt<ConfigurationCubit>();
  }

  void _onConnectionFailure(
    BuildContext context,
    ConnectFailure failure,
  ) {
    onFailureMessage(
      context,
      failure.when(
        unexpected: () => I18n.of(context).failureGeneric,
      ),
    );
  }

  void _onConnectionSuccess(BuildContext context, bool shouldReconnect) {
    if (widget.isInitalConfig) {
      _navigateToDashboardScreen(context);
    } else {
      _navigationPop(context, shouldReconnect);
    }
  }

  void _navigationPop(BuildContext context, bool shouldReconnect) {
    ExtendedNavigator.of(context).pop(shouldReconnect);
  }

  void _navigateToDashboardScreen(BuildContext context) {
    ExtendedNavigator.of(context)
        .pushAndRemoveUntil(Routes.dashboardPage, (route) => false);
  }

  void _onNavigateChangeTheme(BuildContext context) {
    ExtendedNavigator.of(context).pushPreviewPage();
  }

  Future<String> _onGetAdminPin(BuildContext context) async {
    final result = await ExtendedNavigator.of(context).pushCreatePinPage(
      subtitle:
          "Please enter a admin pin which will be used to lock down the settings",
    );
    return result;
  }

  Future<String> _onGetUserPin(BuildContext context) async {
    final result = await ExtendedNavigator.of(context).pushCreatePinPage(
      subtitle:
          "Please enter a user pin which will be used to lock down the application for users.",
    );
    return result;
  }

  Widget _buildMobile(BuildContext context) {
    return SingleChildScrollView(
      child: BuildForm(
          child: FocusScope(
        node: _node,
        child: Column(
          children: [
            _buildMainInputs(context),
            const SizedBox(height: 16),
            _buildApplicationInputs(context),
            const SizedBox(height: 16),
            _buildCredentialInputs(context),
            const SizedBox(height: 72),
          ],
        ),
      )),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Form(
      child: BuildForm(
        child: FocusScope(
          node: _node,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMainInputs(context),
              ),
              SizedBox(
                width: ResponsiveSize.padding(
                  context,
                  size: PaddingSize.medium,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildCredentialInputs(context),
                    SizedBox(
                      height: ResponsiveSize.padding(
                        context,
                        size: PaddingSize.large,
                      ),
                    ),
                    _buildApplicationInputs(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialInputs(BuildContext context) {
    return FormExpansionTile(
      label: "Credentials",
      children: [
        _formUsernameInput(context),
        _formPasswordInput(context),
      ],
    );
  }

  Widget _buildApplicationInputs(BuildContext context) {
    return FormExpansionTile(
      label: "Application",
      children: [
        _themeInput(context),
        _buildAdminPin(context),
        const SizedBox(height: 16),
        _buildUserPin(context),
      ],
    );
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

  Widget _buildMainInputs(BuildContext context) {
    return FormExpansionTile(
      label: "MQTT Broker",
      children: [
        _formHostInput(context),
        _formPortInput(context),
        _formClientIdInput(context),
        _formLayoutTopicInput(context),
      ],
    );
  }

  Widget _formHostInput(BuildContext context) {
    return FormStringInput(
      validation: UrlValidation(
        mapper: (failure) => failure.when(
          invalidUrl: () => "Please provide a valid url.",
          unexpected: () => I18n.of(context).failureGeneric,
        ),
      ),
      label: "Host",
      keyboardType: TextInputType.url,
      initialValue: cubit.state.host,
      onChanged: cubit.setHost,
      onEditingComplete: _node.nextFocus,
    );
  }

  Widget _formPortInput(BuildContext context) {
    return FormIntInput(
      validation: PortValidation(
        mapper: (failure) => failure.when(
          invalidPort: () => "Please provide a valid port number",
          noNumber: () => "Port number can only be numbers",
          unexpected: () => I18n.of(context).failureGeneric,
        ),
      ),
      label: "Port",
      initialValue: cubit.state.port,
      fallbackValue: 1883,
      onChanged: cubit.setPort,
      onEditingComplete: _node.nextFocus,
    );
  }

  Widget _formClientIdInput(BuildContext context) {
    return FormStringInput(
      validation: NonEmptyValidation(
        mapper: (failure) => failure.when(
          empty: () => "Client id is required and can't be empty",
        ),
      ),
      label: "Client Id",
      initialValue: cubit.state.clientId,
      onChanged: cubit.setClientId,
      onEditingComplete: _node.nextFocus,
    );
  }

  Widget _formLayoutTopicInput(BuildContext context) {
    return FormStringInput(
      validation: LayoutTopicValidation(
        mapper: (failure) => failure.when(
          empty: () => "Client id is required and can't be empty",
        ),
      ),
      label: "Layout Topic",
      initialValue: cubit.state.layoutTopic,
      onChanged: cubit.setLayoutTopic,
      onEditingComplete: _node.nextFocus,
    );
  }

  Widget _formUsernameInput(BuildContext context) {
    return FormStringInput(
      validation: NonEmptyValidation(
        mapper: (failure) => failure.when(
          empty: () => "Username is required and can't be empty",
        ),
      ),
      label: "Username",
      initialValue: cubit.state.username,
      onChanged: cubit.setUsername,
      onEditingComplete: _node.nextFocus,
      isRequired: false,
    );
  }

  Widget _formPasswordInput(BuildContext context) {
    return FormStringInput(
      validation: NonEmptyValidation(
        mapper: (failure) => failure.when(
          empty: () => "Password is required and can't be empty",
        ),
      ),
      label: "Password",
      initialValue: cubit.state.password,
      onChanged: cubit.setPassword,
      onEditingComplete: _node.nextFocus,
      textInputAction: TextInputAction.done,
      isRequired: false,
    );
  }

  Widget _buildAdminPin(BuildContext context) {
    return FormPinInput(
      label: "Admin Pin",
      getPin: () => _onGetAdminPin(context),
      initialValue: cubit.state.adminPin,
      onChanged: cubit.setAdminPin,
      isRequired: true,
    );
  }

  Widget _buildUserPin(BuildContext context) {
    return FormPinInput(
        label: "User Pin",
        getPin: () => _onGetUserPin(context),
        initialValue: cubit.state.userPin,
        onChanged: cubit.setUserPin);
  }

  Widget _buildFab(BuildContext context) {
    final fab = FloatingActionButton.extended(
      onPressed: cubit.connect,
      label: const Text("Connect"),
    );

    return BlocBuilder<ConfigurationCubit, ConfigurationState>(
        cubit: cubit,
        builder: (context, state) {
          if (cubit.isValid) {
            return state.connectState.maybeWhen(
              initial: () => fab,
              success: () => fab,
              orElse: () => Container(),
            );
          }
          return Container();
        });
  }

  Widget _buildScaffold(BuildContext context, bool isMobile) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isInitalConfig ? "Configuration" : "Change Configuration",
        ),
      ),
      body: isMobile
          ? _buildMobile(context)
          : SingleChildScrollView(child: _buildTablet(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFab(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);
    return Scaffold(
      body: BlocProvider(
        create: (context) => cubit,
        child: BlocConsumer<ConfigurationCubit, ConfigurationState>(
          cubit: cubit,
          listener: (context, state) {
            state.connectState.maybeWhen(
              loading: () => overlay.showText("Connecting..."),
              failure: (failure) {
                overlay.hide();
                _onConnectionFailure(context, failure);
              },
              success: () {
                overlay.hide();
                _onConnectionSuccess(context, state.shouldReconnect);
              },
              orElse: () => overlay.hide(),
            );
          },
          builder: (context, state) {
            if (!state.dataReady) {
              return Container();
            }
            return ScreenTypeLayout(
              mobile: _buildScaffold(context, true),
              tablet: MasterLayout(
                width: ResponsiveSize.twoWidth(context),
                master: _buildScaffold(context, false),
              ),
            );
          },
        ),
      ),
    );
  }
}
