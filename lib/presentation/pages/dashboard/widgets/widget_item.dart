import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';

import '../../../../application/layout/widget/widget_cubit.dart';
import '../../../../domain/core/internal_state.dart';
import '../../../../domain/layout/entities.dart';
import '../../../../domain/layout/layout_repository_interface.dart';
import '../../../../domain/widget_data/entities.dart';
import '../../../../domain/widget_data/failures.dart';
import '../../../../generated/i18n.dart';
import '../../../mixins/message_mixin.dart';
import '../../../themes/nube_theme.dart';
import '../../../widgets/page_widgets/button_group_widget.dart';
import '../../../widgets/page_widgets/gauge_widget.dart';
import '../../../widgets/page_widgets/invalid_widget.dart';
import '../../../widgets/page_widgets/map_widget.dart';
import '../../../widgets/page_widgets/slider_widget.dart';
import '../../../widgets/page_widgets/switch_widget.dart';
import '../../../widgets/page_widgets/value_widget.dart';

class WidgetItem extends StatelessWidget with MessageMixin {
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
    onFailureMessage(
      context,
      failure.when(
        unexpected: () => I18n.of(context).failureGeneric,
      ),
    );
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
        config: widget.config,
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
            config: widget.config,
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

  Widget _buildTitle(BuildContext context, @nullable WidgetData data) {
    final title = widgetEntity.globalConfig.title;

    final normalColor = Theme.of(context).colorScheme.onSurface.withOpacity(.6);
    final errorColor = Theme.of(context).colorScheme.onError.withOpacity(.6);
    final textColor = _buildErrorState<Color>(
      context,
      normal: title.colors[data?.value] ?? title.color ?? normalColor,
      error: errorColor,
    );

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
    } else if (widgetEntity.globalConfig.initial != null) {
      return _buildWidgets(
        context,
        value: WidgetData(value: widgetEntity.globalConfig.initial),
      );
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
        return widgetEntity is! EditableWidget &&
                widgetEntity.globalConfig.initial == null
            ? error
            : normal;
      },
      orElse: () => normal,
    );
  }

  Color _getWidgetBackground(
    BuildContext context,
    @nullable WidgetData data,
  ) {
    final background = widgetEntity.globalConfig.background;
    return background.colors[data?.value] ??
        background.color ??
        NubeTheme.surfaceOverlay(context, 2);
  }

  WidgetData _getInitialData(
    InternalState<WidgetDataSubscribeFailure> loadState,
    WidgetData data,
  ) {
    final value = loadState.maybeWhen(initial: () => true, orElse: () => false)
        ? widgetEntity.globalConfig.initial
        : data.value;
    return value == null ? null : WidgetData(value: value);
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
                normal: _getWidgetBackground(
                  context,
                  _getInitialData(state.loadState, state.data),
                ),
              ),
              borderRadius: BorderRadius.circular(8.0),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(
                      context, _getInitialData(state.loadState, state.data)),
                  Expanded(
                    child: GridBody(
                      child: state.loadState.when(
                        failure: (failure) =>
                            _buildWidgetError(context, failure),
                        loading: () => _buildWidgetLoading(context),
                        initial: () => _buildInitialWidget(context),
                        success: () =>
                            _buildWidgets(context, value: state.data),
                      ),
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
