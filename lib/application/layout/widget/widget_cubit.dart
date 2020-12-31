import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/core/debounce.dart';
import '../../../domain/core/internal_state.dart';
import '../../../domain/layout/entities.dart';
import '../../../domain/layout/layout_repository_interface.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../domain/widget_data/entities.dart';
import '../../../domain/widget_data/failures.dart';
import '../../../domain/widget_data/widget_data_repository_interface.dart';
import '../../../injectable/injection.dart';

part 'widget_cubit.freezed.dart';
part 'widget_state.dart';

@injectable
class WidgetCubit extends Cubit<WidgetState> {
  final WidgetEntity _widgetEntity;
  final IWidgetDataRepository _widgetDataRepository;

  StreamSubscription stateSubscription;
  StreamSubscription dataSubscription;

  static final factorial = pow(10, 1);
  final debounce = Debouncer(delay: const Duration(milliseconds: 200));
  WidgetData _validData;

  @factoryMethod
  // ignore: prefer_constructors_over_static_methods
  static WidgetCubit create(WidgetEntity widget) => WidgetCubit._(
        widget,
        getIt<IWidgetDataRepository>(),
      );

  WidgetCubit._(
    this._widgetEntity,
    this._widgetDataRepository,
  ) : super(WidgetState.initial()) {
    init();
  }

  @override
  Future<void> close() {
    stateSubscription?.cancel();
    dataSubscription?.cancel();
    return super.close();
  }

  Future<void> init() async {
    final topic = _widgetEntity.topic;
    await _widgetDataRepository.subscribeWidget(topic);

    stateSubscription =
        _widgetDataRepository.getSubscriptionState(topic).listen(
      (event) {
        emit(state.copyWith(
          subscriptionState: event.fold(
            (failure) => MqttSubscriptionState.IDLE,
            (state) => state,
          ),
        ));
      },
    );

    dataSubscription =
        _widgetDataRepository.getWidgetUpdates(topic).listen((event) {
      event.fold(
        (failure) => emit(
          state.copyWith(loadState: InternalState.failure(failure)),
        ),
        (data) {
          _validData = data;
          emit(
            state.copyWith(
              data: data,
              loadState: const InternalState.success(),
            ),
          );
        },
      );
    });
  }

  Future<void> setData(WidgetData value) async {
    _validateAndSet(
      WidgetData(value: (value.value * factorial).round() / factorial),
    );
  }

  Future<bool> _setDataInternal(WidgetData value) async {
    final topic = _widgetEntity.topic;

    final result = await _widgetDataRepository.setData(topic, value);

    return result.fold((failure) {
      emit(state.copyWith(
        data: _validData ?? value,
        widgetSetState: InternalState.failure(failure),
      ));
      return false;
    }, (r) {
      _validData = value;
      emit(state.copyWith(
        data: value,
        widgetSetState: const InternalState.success(),
      ));
      return true;
    });
  }

  void _validateAndSet(WidgetData value) {
    emit(state.copyWith(data: value));
    debounce(() async {
      await _setDataInternal(value);
    });
  }
}
