import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../application/configuration/configuration_cubit.dart';
import '../../../domain/session/failures.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/loading_mixin.dart';
import '../../mixins/message_mixin.dart';
import '../../routes/router.dart';
import '../../themes/nube_theme.dart';
import '../../themes/theme_interface.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';
import '../../widgets/form_elements/theme_input.dart';
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

class _ConnectPageState extends State<ConnectPage>
    with MessageMixin, LoadingMixin {
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

  void _onSaveSuccess(BuildContext context, bool shouldReconnect) {
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
    ExtendedNavigator.of(context).pushAndRemoveUntil(
      Routes.dashboardPage,
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
      onPressed: cubit.save,
      label: const Text("Save"),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: ResponsiveSize.padding(
            context,
            size: PaddingSize.small,
          ),
        ),
        FormPadding(
          child: Text(
            widget.isInitalConfig ? "Configuration" : "Change Configuration",
            style: textTheme.headline1,
          ),
        ),
        FormPadding(
          child: Text(
            "Your personal theme and security settings.",
            style: textTheme.bodyText1,
          ),
        ),
        SizedBox(
          height: ResponsiveSize.padding(
            context,
            size: PaddingSize.large,
          ),
        ),
        _buildLayout(context)
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFab(context),
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
                _onSaveSuccess(context, state.shouldReconnect);
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
