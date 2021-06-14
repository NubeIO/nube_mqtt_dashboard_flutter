import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kt_dart/collection.dart';

import '../../../application/logger/log_cubit.dart';
import '../../../domain/log/entities.dart';
import '../../../domain/log/failures.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../mixins/message_mixin.dart';
import '../../widgets/expandable_text.dart';
import '../../widgets/responsive/master_layout.dart';
import '../../widgets/responsive/screen_type_layout.dart';

class LogsPage extends StatelessWidget with MessageMixin {
  const LogsPage({Key key}) : super(key: key);

  void _onStreamFailure(
    BuildContext context,
    LogStreamFailure failure,
  ) {
    onFailureMessage(
      context,
      failure.when(
        unknown: () => I18n.of(context).failureGeneric,
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    KtList<LogItem> logs,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Logs"),
      ),
      body: ListView.builder(
        itemCount: logs.size,
        itemBuilder: (context, index) {
          final log = logs[index];
          final title = _LogTitle(log: log);
          return log.detail.isEmpty
              ? ListTile(
                  title: title,
                  subtitle: ExpandableText(
                    log.message,
                    expandText: "Show More",
                    collapseText: "Show Less",
                  ),
                )
              : ExpansionTile(
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: title,
                  subtitle: ExpandableText(
                    log.message,
                    expandText: "Show More",
                    collapseText: "Show Less",
                  ),
                  children: [Text(log.detail)],
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<LogCubit>(),
        child: BlocConsumer<LogCubit, LogState>(
          listener: (context, state) {
            state.streamState.maybeWhen(
              failure: (LogStreamFailure failure) {
                _onStreamFailure(context, failure);
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return ScreenTypeLayout(
              mobile: _buildScaffold(context, state.logs),
              tablet: MasterLayout(
                master: _buildScaffold(context, state.logs),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LogTitle extends StatelessWidget {
  final dateFormat = DateFormat.yMd().add_jms();
  _LogTitle({
    Key key,
    @required this.log,
  }) : super(key: key);

  final LogItem log;
  @override
  Widget build(BuildContext context) {
    final logText = log.logLevel.when(
      v: () => "Verbose",
      d: () => "Debug",
      i: () => "Info",
      w: () => "Warning",
      e: () => "Error",
    );
    final theme = Theme.of(context).colorScheme;
    final logColor = log.logLevel.when(
      v: () => theme.primary,
      d: () => theme.primary,
      i: () => theme.primary,
      w: () => theme.secondary,
      e: () => theme.error,
    );
    final logTextColor = log.logLevel.when(
      v: () => theme.onPrimary,
      d: () => theme.onPrimary,
      i: () => theme.onPrimary,
      w: () => theme.onSecondary,
      e: () => theme.onError,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Material(
              color: logColor,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                child: Text(
                  logText,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: logTextColor),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(log.title),
          ],
        ),
        Text(
          dateFormat.format(log.date),
          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12),
        )
      ],
    );
  }
}
