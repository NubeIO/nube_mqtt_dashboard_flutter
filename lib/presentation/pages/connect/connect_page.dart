import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../application/configuration/configuration_cubit.dart';
import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/forms/non_empty_validation.dart';
import '../../../domain/forms/port_validation.dart';
import '../../../domain/forms/url_validation.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../routes/router.dart';
import '../../widgets/form_elements/builder/form_text_builder.dart';
import '../../widgets/form_elements/text_input.dart';
import '../../widgets/overlays/loading.dart';
import '../../widgets/responsive/master_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/responsive/screen_type_layout.dart';
import '../../widgets/responsive/snackbar.dart';

@FramyWidget(isPage: true)
class ConnectPage extends StatefulWidget {
  const ConnectPage({Key key}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  ConfigurationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = getIt<ConfigurationCubit>();
  }

  void _onConnectionFailure(
    BuildContext context,
    SaveAndConnectFailure failure,
  ) {
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
      width: ResponsiveSize.twoWidth(context),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void _onConnectionSuccess(BuildContext context) {
    _navigateToDashboardScreen(context);
  }

  void _navigateToDashboardScreen(BuildContext context) {
    ExtendedNavigator.of(context)
        .pushAndRemoveUntil(Routes.dashboardPage, (route) => false);
  }

  Widget _buildMobile(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.padding(
              context,
              size: PaddingSize.medium,
            ),
            vertical: ResponsiveSize.padding(
              context,
              size: PaddingSize.small,
            ),
          ),
          child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  _buildMainInputs(context),
                  const SizedBox(height: 16),
                  _buildCredentialInputs(context)
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.padding(
            context,
            size: PaddingSize.medium,
          ),
          vertical: ResponsiveSize.padding(
            context,
            size: PaddingSize.small,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                child: _buildCredentialInputs(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  ExpansionTile _buildCredentialInputs(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Credentials",
        style: Theme.of(context).textTheme.headline3,
      ),
      maintainState: true,
      initiallyExpanded: true,
      tilePadding: EdgeInsets.zero,
      children: [_formUsernameInput(context), _formPasswordInput(context)],
    );
  }

  ExpansionTile _buildMainInputs(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "MQTT Broker",
        style: Theme.of(context).textTheme.headline3,
      ),
      maintainState: true,
      initiallyExpanded: true,
      tilePadding: EdgeInsets.zero,
      children: [
        _formHostInput(context),
        _formPortInput(context),
        _formClientIdInput(context)
      ],
    );
  }

  FormTextBuilder<String> _formHostInput(BuildContext context) {
    return FormTextBuilder<String>(
      validation: UrlValidation(
        mapper: (failure) => failure.when(
          invalidUrl: () => "Please provide a valid url.",
          unexpected: () => I18n.of(context).failureGeneric,
        ),
      ),
      builder: (context, state, onValueChanged) {
        return TextInput(
          initialValue: cubit.state.host.getOrElse(""),
          validationState: state,
          onValueChanged: onValueChanged,
          label: "Host",
          keyboardType: TextInputType.url,
        );
      },
      validityListener: (value, valid) {
        cubit.setHost(value);
      },
    );
  }

  Widget _formPortInput(BuildContext context) {
    return FormTextBuilder<int>(
      validation: PortValidation(
        mapper: (failure) => failure.when(
          invalidPort: () => "Please provide a valid port number",
          noNumber: () => "Port number can only be numbers",
          unexpected: () => I18n.of(context).failureGeneric,
        ),
      ),
      builder: (context, state, onValueChanged) {
        return TextInput(
          initialValue: cubit.state.port.getOrElse(1883).toString(),
          validationState: state,
          onValueChanged: onValueChanged,
          label: "Port",
          keyboardType: TextInputType.number,
        );
      },
      validityListener: (value, valid) {
        cubit.setPort(value);
      },
    );
  }

  Widget _formClientIdInput(BuildContext context) {
    return FormTextBuilder<String>(
      validation: NonEmptyValidation(
        mapper: (failure) => failure.when(
          empty: () => "Client id is required and can't be empty",
        ),
      ),
      builder: (context, state, onValueChanged) {
        return TextInput(
          initialValue: cubit.state.clientId.getOrElse(""),
          validationState: state,
          onValueChanged: onValueChanged,
          label: "Client Id",
          keyboardType: TextInputType.text,
        );
      },
      validityListener: (value, valid) {
        cubit.setClientId(value);
      },
    );
  }

  Widget _formUsernameInput(BuildContext context) {
    return FormTextBuilder<String>(
      validation: NonEmptyValidation(
        mapper: (failure) => failure.when(
          empty: () => "Username is required and can't be empty",
        ),
      ),
      builder: (context, state, onValueChanged) {
        return TextInput(
          initialValue: cubit.state.username.getOrElse(""),
          validationState: state,
          onValueChanged: onValueChanged,
          label: "Username",
          keyboardType: TextInputType.text,
        );
      },
      validityListener: (value, valid) {
        cubit.setUsername(value);
      },
    );
  }

  Widget _formPasswordInput(BuildContext context) {
    return FormTextBuilder<String>(
      validation: NonEmptyValidation(
        mapper: (failure) => failure.when(
          empty: () => "Password is required and can't be empty",
        ),
      ),
      builder: (context, state, onValueChanged) {
        return TextInput(
          initialValue: cubit.state.password.getOrElse(""),
          validationState: state,
          onValueChanged: onValueChanged,
          label: "Password",
          keyboardType: TextInputType.text,
        );
      },
      validityListener: (value, valid) {
        cubit.setPassword(value);
      },
    );
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
        title: const Text("Configuration"),
      ),
      body: isMobile ? _buildMobile(context) : _buildTablet(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFab(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

    return Scaffold(
      body: BlocConsumer<ConfigurationCubit, ConfigurationState>(
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
              _onConnectionSuccess(context);
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
    );
  }
}
