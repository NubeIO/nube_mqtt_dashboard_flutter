import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/alerts/alerts_cubit.dart';
import '../../../injectable/injection.dart';
import '../../widgets/animated/illustration_alerts.dart';
import '../../widgets/responsive/master_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/responsive/screen_type_layout.dart';
import '../../widgets/text/page_info_widget.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({Key key}) : super(key: key);

  Widget _buildScaffold(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Alerts"),
      ),
      body: const EmptyAlerts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<AlertsCubit>(),
        child: BlocConsumer<AlertsCubit, AlertsState>(
          listener: (context, state) {},
          builder: (context, state) {
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

class EmptyAlerts extends StatelessWidget {
  const EmptyAlerts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveSize.padding(
            context,
            size: PaddingSize.medium,
          )),
          child: const AspectRatio(
            aspectRatio: 1,
            child: EmptyAlertsIllustration(
              size: Size.infinite,
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveSize.padding(
            context,
            size: PaddingSize.medium,
          ),
        ),
        const PageInfoText(
          title: "No Alerts",
          subtitle: "All your alerts appear here.",
        ),
        SizedBox(
          height: ResponsiveSize.padding(
            context,
            size: PaddingSize.xlarge,
          ),
        ),
      ],
    );
  }
}
