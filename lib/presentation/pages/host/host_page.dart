import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/host/host_cubit.dart';
import '../../../domain/forms/port_validation.dart';
import '../../../domain/forms/url_validation.dart';
import '../../../domain/network/host_repository_interface.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/loading_mixin.dart';
import '../../mixins/message_mixin.dart';
import '../../routes/router.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';

class HostPage extends StatelessWidget with MessageMixin, LoadingMixin {
  final FocusScopeNode _node = FocusScopeNode();
  final bool isRegistrationStep;

  HostPage({
    Key key,
    this.isRegistrationStep = true,
  }) : super(key: key);

  void _onConnectionFailure(BuildContext context, SetHostFailure failure) {
    onFailureMessage(
      context,
      failure.when(unexpected: () => I18n.of(context).failureGeneric),
    );
  }

  void _onConnectionSuccess(BuildContext context) {
    if (isRegistrationStep) {
      ExtendedNavigator.of(context).pushRegisterPage();
    } else {
      ExtendedNavigator.of(context).pushLoginPage();
    }
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
      initialValue: context.watch<HostCubit>().state.host,
      onChanged: context.watch<HostCubit>().setHost,
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
      textInputAction: TextInputAction.done,
      initialValue: context.watch<HostCubit>().state.port,
      onChanged: context.watch<HostCubit>().setPort,
    );
  }

  Widget _buildFab(BuildContext context) {
    final cubit = context.watch<HostCubit>();

    final fab = FloatingActionButton.extended(
      onPressed: cubit.connect,
      label: const Text("Connect"),
    );

    return BlocBuilder<HostCubit, HostState>(builder: (context, state) {
      if (cubit.isValid) {
        return state.saveConfigState.maybeWhen(
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
            _formHostInput(context),
            _formPortInput(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<HostCubit>(),
        child: BlocConsumer<HostCubit, HostState>(
          listener: (context, state) {
            state.saveConfigState.maybeWhen(
              loading: () => showLoading(context, message: "Connecting..."),
              failure: (failure) {
                hideLoading(context);
                _onConnectionFailure(context, failure);
              },
              success: () {
                hideLoading(context);
                _onConnectionSuccess(context);
              },
              orElse: () => hideLoading(context),
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
                  const FormInfoWidget(
                    title: "Server Configuration",
                    subtitle: "Enter the server IP and Port Address",
                  ),
                  _buildMainInputs(context)
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: _buildFab(context),
            );
          },
        ),
      ),
    );
  }
}
