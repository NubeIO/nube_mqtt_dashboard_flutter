import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/layout/widget/widget_cubit.dart';
import '../../../../domain/layout/entities.dart';
import '../../../../domain/mqtt/mqtt_repository.dart';
import '../../../../domain/widget_data/entities.dart';
import '../../../../domain/widget_data/failures.dart';
import '../../../themes/nube_theme.dart';
import '../../../widgets/page_widgets/gauge_widget.dart';
import '../../../widgets/page_widgets/slider_widget.dart';
import '../../../widgets/page_widgets/switch_widget.dart';
import '../../../widgets/page_widgets/value_widget.dart';
import '../../../widgets/responsive/padding.dart';

class WidgetItem extends StatelessWidget {
  final WidgetEntity widgetEntity;

  const WidgetItem({
    Key key,
    @required this.widgetEntity,
  }) : super(key: key);

  void _onChange(BuildContext context, WidgetData value) {
    context.read<WidgetCubit>().setData(value);
  }

  Color _subscriptionColor(
    BuildContext context,
    MqttSubscriptionState subscriptionState,
  ) {
    switch (subscriptionState) {
      case MqttSubscriptionState.IDLE:
        return Colors.grey;
      case MqttSubscriptionState.SUBSCRIBED:
        return Colors.green;
      case MqttSubscriptionState.PENDING:
        return Colors.amber;
    }
    return Colors.grey;
  }

  Widget _buildWidgets(
    BuildContext context, {
    @required WidgetData value,
    bool isDefault = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveSize.padding(
          context,
          size: PaddingSize.medium,
        ),
        bottom: ResponsiveSize.padding(context),
        left: ResponsiveSize.padding(context),
        right: ResponsiveSize.padding(context),
      ),
      child: Center(
        child: widgetEntity.map(
          gaugeWidget: (widget) => GaugeWidget(
            value: value,
            config: widget.config,
            onChange: (value) => _onChange(
              context,
              value,
            ),
          ),
          sliderWidget: (widget) => SliderWidget(
            value: isDefault ? widget.defaultValue : value,
            config: widget.config,
            onChange: (value) => _onChange(
              context,
              value,
            ),
          ),
          switchWidget: (widget) => SwitchWidget(
            value: isDefault ? widget.defaultValue : value,
            config: widget.config,
            onChange: (value) => _onChange(
              context,
              value,
            ),
          ),
          valueWidget: (widget) => ValueWidget(
            value: value,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveSize.padding(
            context,
            size: PaddingSize.xsmall,
          )),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Text(
          widgetEntity.name,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Text(widgetEntity.topic, style: Theme.of(context).textTheme.caption),
          const Spacer(),
          BlocBuilder<WidgetCubit, WidgetState>(builder: (context, state) {
            return Icon(
              Icons.circle,
              size: 12,
              color: _subscriptionColor(context, state.subscriptionState),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWidgetError(
    BuildContext context,
    WidgetDataSubscribeFailure failure,
  ) {
    return Center(
      child: Text(
        failure.when(unexpected: () => "Something went wrong."),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontSize: 20, color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Widget _buildWidgetLoading(
    BuildContext context,
  ) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildInitialWidget(
    BuildContext context,
  ) {
    if (widgetEntity is EditableWidget) {
      return _buildWidgets(context, value: null, isDefault: true);
    }
    return Center(
      child: Text(
        "No Data Loaded",
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WidgetCubit>(
      create: (context) => WidgetCubit.create(widgetEntity),
      child: Material(
        color: NubeTheme.surfaceOverlay(context, 2),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.padding(
            context,
            size: PaddingSize.xsmall,
          )),
        ),
        child: GridTile(
          header: _buildTitle(context),
          footer: _buildFooter(context),
          child: BlocBuilder<WidgetCubit, WidgetState>(
            builder: (context, state) {
              return state.loadState.when(
                  failure: (failure) => _buildWidgetError(context, failure),
                  loading: () => _buildWidgetLoading(context),
                  initial: () => _buildInitialWidget(context),
                  success: (value) => _buildWidgets(context, value: value));
            },
          ),
        ),
      ),
    );
  }
}
