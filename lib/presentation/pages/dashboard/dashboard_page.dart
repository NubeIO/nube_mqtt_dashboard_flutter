import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/alerts/alerts_cubit.dart';
import '../../../application/configuration/configuration_cubit.dart';
import '../../../application/layout/layout_cubit.dart';
import '../../../domain/layout/entities.dart';
import '../../../domain/layout/failures.dart';
import '../../../domain/theme/entities.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/loading_mixin.dart';
import '../../mixins/message_mixin.dart';
import '../../routes/router.dart';
import '../../themes/nube_theme.dart';
import '../../widgets/icons/alert_badge.dart';
import '../../widgets/logo_widget.dart';
import '../../widgets/responsive/drawer_detail_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/variable_menu_item.dart';
import 'widgets/empty_layout.dart';
import 'widgets/page_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with MessageMixin, LoadingMixin {
  final cubit = getIt<LayoutCubit>();
  final configurationCubit = getIt<ConfigurationCubit>();

  Future<void> _navigateToVerifyAdminPin(BuildContext context) async {
    final isPinProtected = await configurationCubit.isPinProtected();
    if (isPinProtected) {
      final result = await ExtendedNavigator.of(context).pushValidatePinPage();
      if (result != null) {
        _navigateToSettings(context);
      }
    } else {
      _navigateToSettings(context);
    }
  }

  Future<void> _navigateToSettings(BuildContext context) async {
    await ExtendedNavigator.of(context).pushConnectPage();
  }

  void _onNavigateToAlerts(BuildContext context) {
    ExtendedNavigator.of(context).pushAlertsPage();
  }

  Future<void> _navigateToLogs(BuildContext context) async {
    final isPinProtected = await configurationCubit.isPinProtected();

    if (isPinProtected) {
      final result = await ExtendedNavigator.of(context).pushValidatePinPage();
      if (result != null) {
        ExtendedNavigator.of(context).pushLogsPage();
      }
    } else {
      ExtendedNavigator.of(context).pushLogsPage();
    }
  }

  void _onFailure(
    BuildContext context,
    LayoutFailure failure,
  ) {
    onFailureMessage(
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
    onFailureMessage(
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
      if (result != null) {
        navigate();
      }
    } else {
      navigate();
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => _navigateToLogs(context),
          leading: const Icon(Icons.dns),
          title: const Text("Logs"),
        ),
        ListTile(
          onTap: () => _navigateToVerifyAdminPin(context),
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
        )
      ],
    );
  }

  Widget _buildWidgetScreen(PageEntity selectedPage) {
    return selectedPage != null
        ? WidgetsScreen(
            key: ValueKey(selectedPage.id),
            page: selectedPage,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
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
                hideLoading(context);
                _onConnectFailure(context, failure);
              },
              success: () => hideLoading(context),
              orElse: () => showLoading(context),
            );
          },
          builder: (context, state) {
            final rootList = state.layout.pages;
            final isEmptyState = state.layout.isEmptyState;
            final logo = state.layout.logo;
            final selectedPage = state.selectedPage;
            return DrawerDetailLayout(
              defaultAppBar: AppBar(
                elevation: 4,
                backgroundColor: NubeTheme.backgroundOverlay(context),
                actions: appbarActions(
                  onNotificationPressed: () => _onNavigateToAlerts(context),
                ),
              ),
              appBarBuilder: (context, state) => dashboardAppBar(context,
                  state: state,
                  logo: logo,
                  name: selectedPage?.name,
                  onNotificationPressed: () => _onNavigateToAlerts(context)),
              header: Padding(
                padding: EdgeInsets.all(ResponsiveSize.padding(context)),
                child: LogoWidget(
                  logo: logo,
                  size: Size.large,
                ),
              ),
              detailBuilder: isEmptyState
                  ? const EmptyLayout()
                  : _buildWidgetScreen(selectedPage),
              itemBuilder: (context, index) {
                final currentItem = rootList[index];
                return VariableMenuItem(
                  page: currentItem,
                  selectedId: selectedPage?.id,
                  onSelected: (context, page) =>
                      _onProtectedNavigation(context, page: page),
                );
              },
              itemCount: rootList.size,
              footer: _buildFooter(context),
            );
          },
        ),
      ),
    );
  }
}

AppBar dashboardAppBar(
  BuildContext context, {
  ScaffoldState state,
  @required Logo logo,
  @required String name,
  @required void Function() onNotificationPressed,
}) {
  final iconSize = logo.size;
  final smallPadding =
      ResponsiveSize.padding(context, size: PaddingSize.xsmall);
  final verticalPadding =
      ResponsiveSize.padding(context, size: PaddingSize.small);
  final horizontalPadding = ResponsiveSize.padding(context);
  if (!logo.showIcon) {
    return AppBar(
      titleSpacing: 0,
      centerTitle: false,
      actions: appbarActions(
        onNotificationPressed: () => onNotificationPressed(),
      ),
      backgroundColor: NubeTheme.backgroundOverlay(context, 0),
      title: appbarTitle(name, context),
    );
  }
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: iconSize + verticalPadding * 2,
    leadingWidth: iconSize + horizontalPadding * 2,
    leading: IconButton(
      onPressed: () {
        state?.openDrawer();
      },
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      icon: Padding(
        padding: EdgeInsets.only(left: smallPadding),
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: Material(
            color: NubeTheme.surfaceOverlay(context, 2),
            borderRadius: BorderRadius.circular(smallPadding),
            child: LogoWidget(
              logo: logo,
            ),
          ),
        ),
      ),
    ),
    actions: appbarActions(
      onNotificationPressed: () => onNotificationPressed(),
    ),
    titleSpacing: 0,
    centerTitle: false,
    backgroundColor: NubeTheme.backgroundOverlay(context, 0),
    title: appbarTitle(name, context),
  );
}

Text appbarTitle(String name, BuildContext context) {
  return Text(
    name ?? "No Layout",
    style: Theme.of(context).textTheme.headline1.copyWith(
          color: NubeTheme.colorText200(context),
        ),
  );
}

List<Widget> appbarActions({
  @required void Function() onNotificationPressed,
}) {
  return [
    BlocProvider<AlertsCubit>(
      create: (context) => getIt<AlertsCubit>(),
      child: BlocBuilder<AlertsCubit, AlertsState>(
        builder: (context, state) {
          return state.alertState.maybeWhen(
            success: () => AlertBadgeIcon(
              onNotificationPressed: onNotificationPressed,
              count: state.alert.alerts.size,
            ),
            orElse: () => AlertBadgeIcon(
              onNotificationPressed: onNotificationPressed,
            ),
          );
        },
      ),
    ),
  ];
}
