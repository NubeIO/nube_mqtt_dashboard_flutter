import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../application/alerts/alerts_cubit.dart';
import '../../../domain/notifications/entities.dart';
import '../../../domain/notifications/failures.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/message_mixin.dart';
import '../../widgets/animated/illustration_alerts.dart';
import '../../widgets/responsive/master_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/responsive/screen_type_layout.dart';
import '../../widgets/text/page_info_widget.dart';

class AlertsPage extends StatelessWidget with MessageMixin {
  const AlertsPage({Key key}) : super(key: key);

  void _onStreamFailure(
    BuildContext context,
    AlertFailure failure,
  ) {
    onFailureMessage(
      context,
      failure.when(
        invalidAlert: () =>
            "Something went wrong while trying to fetch alerts.",
        unexpected: () => I18n.of(context).failureGeneric,
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Alerts"),
      ),
      body: BlocProvider(
        create: (context) => getIt<AlertsCubit>(),
        child: BlocConsumer<AlertsCubit, AlertsState>(
          listener: (context, state) {
            state.alertState.maybeWhen(
              failure: (failure) {
                _onStreamFailure(context, failure);
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final alerts = state.alert.alerts;
            return alerts.isEmpty()
                ? const EmptyAlerts()
                : ListView.builder(
                    itemCount: alerts.size,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      final siteName = alert.site?.name ?? "Invalid Site";
                      return ListTile(
                        leading: AlertTypeIcon(
                          text: alert.alertType,
                          priority: alert.priority,
                        ),
                        title: _AlertTitle(alert: alert),
                        subtitle: Text("$siteName | ${alert.subtitle}"),
                      );
                    },
                  );
          },
        ),
      ),
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

class AlertTypeIcon extends StatelessWidget {
  final String text;
  final Priority priority;
  const AlertTypeIcon({
    Key key,
    @required this.text,
    this.priority = const Priority.normal(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priorityColor = priority.when(
      high: () => colorScheme.error,
      low: () => null,
      normal: () => colorScheme.primary,
    );
    return SizedBox(
      width: 80,
      child: Material(
        color: priorityColor,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 2.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
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

class _AlertTitle extends StatelessWidget {
  final dateFormat = DateFormat.yMd().add_jms();
  _AlertTitle({
    Key key,
    @required this.alert,
  }) : super(key: key);

  final Alert alert;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(alert.title),
        Text(
          dateFormat.format(alert.timestamp),
          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
