import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framy_annotation/framy_annotation.dart';
import 'package:nube_mqtt_dashboard/domain/layout/entities.dart';

import '../../../application/layout/layout_cubit.dart';
import '../../../domain/layout/failures.dart';
import '../../../domain/session/entities.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../routes/router.dart';
import '../../themes/nube_theme.dart';
import '../../widgets/overlays/loading.dart';
import '../../widgets/responsive/drawer_detail_layout.dart';
import '../../widgets/responsive/snackbar.dart';
import 'widgets/page_screen.dart';

@FramyWidget(isPage: true)
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  final cubit = getIt<LayoutCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      cubit.init();
    }
  }

  Future<void> _navigateToVerifyAdminPin(BuildContext context) async {
    final result = await ExtendedNavigator.of(context).pushValidatePinPage();
    switch (result) {
      case UserType.USER:
        _onFailureMessage(
            context, "Sorry you need don't have access to settings");
        break;
      case UserType.ADMIN:
        _navigateToSettings(context);
        break;
      default:
    }
  }

  Future<void> _navigateToSettings(BuildContext context) async {
    final result = await ExtendedNavigator.of(context).pushConnectPage();
    if (result == null) return;

    cubit.init(shouldReconnect: result);
  }

  void _onFailure(
    BuildContext context,
    LayoutFailure failure,
  ) {
    _onFailureMessage(
      context,
      failure.when(
          unexpected: () => I18n.of(context).failureGeneric,
          invalidLayout: () =>
              "Opps! The layout doesn't seem to be valid. Please contact .",
          noLayoutConfig: () =>
              "No layout config found. Please check in setttings."),
    );
  }

  void _onConnectFailure(
    BuildContext context,
    LayoutSubscribeFailure failure,
  ) {
    _onFailureMessage(
      context,
      failure.when(
        unexpected: () => I18n.of(context).failureGeneric,
        noLayoutConfig: () =>
            "No layout config found. Please check in setttings.",
        invalidConection: () =>
            "Please make sure you have an active connection.",
      ),
    );
  }

  Future<void> _onProtectedNavigation(
    BuildContext context, {
    @required PageEntity page,
  }) async {
    if (cubit.state.selectedPage == page) {
      Navigator.pop(context);
      return;
    }

    // Navigate and Start Timeout
    void navigate() {
      Navigator.pop(context);
      cubit.setSelected(page);
      cubit.startTimeout(page.config);
    }

    if (page.config.protected) {
      final result = await ExtendedNavigator.of(context).pushValidatePinPage();
      switch (result) {
        case UserType.USER:
        case UserType.ADMIN:
          navigate();
          break;
        default:
      }
    } else {
      navigate();
    }
  }

  void _onFailureMessage(BuildContext context, String message) {
    final snackbar = ResponsiveSnackbar.build(
      context,
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).colorScheme.error),
      ),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => _navigateToVerifyAdminPin(context),
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

    return Scaffold(
      body: BlocProvider(
        create: (context) => cubit,
        child: BlocConsumer<LayoutCubit, LayoutState>(
          listener: (context, state) {
            state.layoutState.maybeWhen(
                failure: (failure) {
                  _onFailure(context, failure);
                },
                orElse: () {});

            state.layoutConnection.maybeWhen(
              failure: (failure) {
                overlay.hide();
                _onConnectFailure(context, failure);
              },
              success: () => overlay.hide(),
              orElse: () => overlay.show(),
            );
          },
          builder: (context, state) {
            final list = state.layout.pages;
            final selectedPage = state.selectedPage;
            return DrawerDetailLayout(
              appBar: AppBar(
                elevation: 4,
                backgroundColor: NubeTheme.backgroundOverlay(context),
                title: Text(selectedPage?.name ?? "No Layout"),
              ),
              detailBuilder: selectedPage != null
                  ? WidgetsScreen(
                      key: ValueKey(selectedPage.id),
                      page: selectedPage,
                    )
                  : Container(),
              itemBuilder: (context, index) {
                final currentItem = list[index];
                final selected = selectedPage?.id == currentItem.id;
                return ListTile(
                  selected: selected,
                  onTap: () => _onProtectedNavigation(
                    context,
                    page: currentItem,
                  ),
                  title: Text(currentItem.name),
                );
              },
              itemCount: list.size,
              footer: _buildFooter(context),
            );
          },
        ),
      ),
    );
  }
}
