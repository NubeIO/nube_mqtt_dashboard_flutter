import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/layout/widget/widget_cubit.dart';
import '../../../../domain/layout/entities.dart';
import '../../../../domain/layout/layout_repository_interface.dart';
import '../../../../domain/mqtt/mqtt_repository.dart';
import '../../../../domain/widget_data/entities.dart';
import '../../../../domain/widget_data/failures.dart';
import '../../../../generated/i18n.dart';
import '../../../themes/nube_theme.dart';
import '../../../widgets/page_widgets/button_group_widget.dart';
import '../../../widgets/page_widgets/gauge_widget.dart';
import '../../../widgets/page_widgets/invalid_widget.dart';
import '../../../widgets/page_widgets/map_widget.dart';
import '../../../widgets/page_widgets/slider_widget.dart';
import '../../../widgets/page_widgets/switch_widget.dart';
import '../../../widgets/page_widgets/value_widget.dart';
import '../../../widgets/responsive/padding.dart';
import '../../../widgets/responsive/snackbar.dart';

class WidgetItem extends StatelessWidget {
  final WidgetEntity widgetEntity;

  const WidgetItem({
    Key key,
    @required this.widgetEntity,
  }) : super(key: key);

  void _onChange(BuildContext context, WidgetData value) {
    context.read<WidgetCubit>().setData(value);
  }

  void _onSetFailure(
    BuildContext context,
    WidgetSetFailure failure,
  ) {
    final snackbar = ResponsiveSnackbar.build(
      context,
      content: Text(
        failure.when(
          unexpected: () => I18n.of(context).failureGeneric,
        ),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).colorScheme.error),
      ),
      direction: Direction.left,
      width: ResponsiveSize.twoWidth(context),
    );
    Scaffold.of(context).showSnackBar(snackbar);
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
    return widgetEntity.map(
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
        unit: widget.config.unit,
      ),
      switchGroupWidget: (widget) {
        return SwitchGroupWidget(
          value: isDefault ? widget.defaultValue : value,
          config: widget.config,
          onChange: (value) => _onChange(
            context,
            value,
          ),
        );
      },
      mapWidget: (widget) {
        return _buildErrorState(
          context,
          normal: MapWidget(
            value: value,
            maps: widget.config.maps,
            colors: widget.config.colors,
          ),
          error: _buildFailureWidget(
            title: "N/A Map",
            subtitle: "Invalid data provided",
          ),
        );
      },
      failure: (value) => _buildParseFailureWidget(value.failure),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final title = widgetEntity.globalConfig.title;

    final normalColor = title.color ?? Theme.of(context).colorScheme.onSurface;
    final errorColor = Theme.of(context).colorScheme.onError;
    final textColor = _buildErrorState<Color>(
      context,
      normal: normalColor,
      error: errorColor,
    ).withOpacity(.6);

    final textStyle = Theme.of(context).textTheme.bodyText1;
    final fontSize = title.fontSize ?? textStyle.fontSize;

    final textAlign = title.align.when(
      center: () => TextAlign.center,
      left: () => TextAlign.left,
      right: () => TextAlign.right,
    );

    return GridTileBar(
      title: Text(
        widgetEntity.name,
        textAlign: textAlign,
        style: textStyle.copyWith(color: textColor, fontSize: fontSize),
      ),
      trailing: _buildErrorState<Widget>(
        context,
        normal: const SizedBox.shrink(),
        error: Icon(
          Icons.error,
          color: errorColor,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final normalColor = Theme.of(context).colorScheme.onSurface;
    final errorColor = Theme.of(context).colorScheme.onError;
    final textColor = _buildErrorState<Color>(
      context,
      normal: normalColor,
      error: errorColor,
    ).withOpacity(.6);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        widgetEntity.topic.read,
        style: Theme.of(context).textTheme.caption.copyWith(
              color: textColor,
            ),
      ),
    );
  }

  Widget _buildWidgetError(
    BuildContext context,
    WidgetDataSubscribeFailure failure,
  ) {
    return ErrorTypeWidget(
      title: failure.map(unexpected: (_) => "Unexpected Error"),
      subtitle: "Please try again later.",
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
    return widgetEntity.maybeMap(
      failure: (value) => _buildParseFailureWidget(value.failure),
      orElse: () => const ErrorTypeWidget(
        title: "N/A",
        subtitle: "No data available",
      ),
    );
  }

  Widget _buildParseFailureWidget(LayoutParseFailure failure) {
    return _buildFailureWidget(
      title: failure.when(
        unknown: () => "Error",
        parse: () => "Error Parsing Widget",
      ),
      subtitle: failure.when(
        unknown: () => "Unknown Widget Type.",
        parse: () => "Something went wrong when trying to parse widget data.",
      ),
    );
  }

  Widget _buildFailureWidget({
    @required String title,
    @required String subtitle,
  }) {
    return ErrorTypeWidget(
      title: title,
      subtitle: subtitle,
    );
  }

  T _buildErrorState<T>(
    BuildContext context, {
    @required T normal,
    @required T error,
  }) {
    final state = BlocProvider.of<WidgetCubit>(context).state;
    return state.loadState.maybeWhen(
      failure: (_) => error,
      success: () {
        return widgetEntity.maybeMap(
          mapWidget: (widget) {
            if (widget.config.maps.containsKey(state.data.value)) {
              return normal;
            }
            return error;
          },
          failure: (_) => error,
          orElse: () => normal,
        );
      },
      initial: () {
        if (widgetEntity is EditableWidget) {
          return normal;
        } else {
          return error;
        }
      },
      orElse: () => normal,
    );
  }

  Color _getWidgetBackground(BuildContext context, WidgetData data) {
    final background = widgetEntity.globalConfig.background;
    return background.colors[data.value] ??
        background.color ??
        NubeTheme.surfaceOverlay(context, 2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WidgetCubit>(
      create: (context) => WidgetCubit.create(widgetEntity),
      child: BlocConsumer<WidgetCubit, WidgetState>(
        listener: (context, state) {
          state.widgetSetState.maybeWhen(
            failure: (failure) {
              _onSetFailure(context, failure);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Material(
              color: _buildErrorState<Color>(
                context,
                error: Theme.of(context).colorScheme.error,
                normal: _getWidgetBackground(context, state.data),
              ),
              borderRadius: BorderRadius.circular(8.0),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  Expanded(
                    child: GridBody(
                      child: state.loadState.when(
                          failure: (failure) =>
                              _buildWidgetError(context, failure),
                          loading: () => _buildWidgetLoading(context),
                          initial: () => _buildInitialWidget(context),
                          success: () =>
                              _buildWidgets(context, value: state.data)),
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

class GridBody extends StatelessWidget {
  final Widget child;
  const GridBody({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: child,
    );
  }
}
