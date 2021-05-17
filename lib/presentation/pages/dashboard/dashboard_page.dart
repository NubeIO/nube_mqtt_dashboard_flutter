import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framy_annotation/framy_annotation.dart';

import '../../../application/layout/layout_cubit.dart';
import '../../../domain/layout/entities.dart';
import '../../../domain/layout/failures.dart';
import '../../../domain/theme/entities.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/message_mixin.dart';
import '../../routes/router.dart';
import '../../themes/nube_theme.dart';
import '../../widgets/logo_widget.dart';
import '../../widgets/overlays/loading.dart';
import '../../widgets/responsive/drawer_detail_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/variable_menu_item.dart';
import 'widgets/page_screen.dart';

@FramyWidget(isPage: true)
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver, MessageMixin {
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
    if (result != null) {
      _navigateToSettings(context);
    }
  }

  Future<void> _navigateToSettings(BuildContext context) async {
    final result = await ExtendedNavigator.of(context).pushConnectPage();
    if (result == null) return;

    cubit.init(shouldReconnect: result);
  }

  Future<void> _navigateToLogs(BuildContext context) async {
    final result = await ExtendedNavigator.of(context).pushValidatePinPage();
    if (result != null) {
      await ExtendedNavigator.of(context).pushLogsPage();
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
            final rootList = state.layout.pages;
            final logo = state.layout.logo;
            final selectedPage = state.selectedPage;
            return DrawerDetailLayout(
              appBarBuilder: (context, state) => dashboardAppBar(
                context,
                state: state,
                logo: logo,
                name: selectedPage?.name,
              ),
              header: Padding(
                padding: EdgeInsets.all(ResponsiveSize.padding(context)),
                child: LogoWidget(
                  logo: logo,
                  size: Size.large,
                ),
              ),
              detailBuilder: selectedPage != null
                  ? WidgetsScreen(
                      key: ValueKey(selectedPage.id),
                      page: selectedPage,
                    )
                  : Container(),
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
      backgroundColor: NubeTheme.backgroundOverlay(context, 0),
      title: Text(
        name ?? "No Layout",
        style: Theme.of(context).textTheme.headline1.copyWith(
              color: NubeTheme.colorText200(context),
            ),
      ),
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
    titleSpacing: 0,
    centerTitle: false,
    backgroundColor: NubeTheme.backgroundOverlay(context, 0),
    title: Text(
      name ?? "No Layout",
      style: Theme.of(context).textTheme.headline1.copyWith(
            color: NubeTheme.colorText200(context),
          ),
    ),
  );
}
