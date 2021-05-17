import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/alerts/alerts_cubit.dart';
import '../../../injectable/injection.dart';
import '../../widgets/animated/illustration_alerts.dart';
import '../../widgets/responsive/master_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/responsive/screen_type_layout.dart';

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
    final textTheme = Theme.of(context).textTheme;

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
        Text(
          "No Alerts",
          style: textTheme.headline1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.padding(
              context,
              size: PaddingSize.large,
            ),
            vertical: ResponsiveSize.padding(
              context,
              size: PaddingSize.small,
            ),
          ),
          child: Text(
            "All your alerts appear here.",
            style: textTheme.bodyText1,
          ),
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
