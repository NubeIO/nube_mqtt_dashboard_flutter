import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/layout/layout_repository_interface.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../utils/logger/log.dart';
import '../managers/layout_data_preference.dart';
import '../mappers/layout.dart';
import '../models/layout.dart';

const _TAG = "LayoutRepository";

@LazySingleton(as: ILayoutRepository)
class LayoutRepositoryImpl extends ILayoutRepository {
  final IMqttRepository _mqttRepository;
  final IConfigurationRepository _configurationRepository;
  final LayoutPreferenceManager _layoutPreferenceManager;

  LayoutRepositoryImpl(
    this._mqttRepository,
    this._configurationRepository,
    this._layoutPreferenceManager,
  );

  final layoutMapper = LayoutMapper();

  @override
  Stream<Either<LayoutFailure, LayoutEntity>> get layoutStream async* {
    final message = _layoutPreferenceManager.message;
    if (message != null) {
      final result = await _mapToLayoutBuilder(message);
      if (result.isRight()) {
        yield result.fold(
          (l) => throw AssertionError(),
          (layout) => Right(layout),
        );
      }
    } else {
      yield Right(LayoutEntity.empty(isEmptyState: true));
    }
    bool isInitial = true;
    String currentLayout;
    yield* _configurationRepository.layoutTopicStream.flatMap((layout) async* {
      Log.d("New Layout Topic $layout", tag: _TAG);
      currentLayout = layout;
      await _mqttRepository.connectionStream
          .firstWhere((element) => element == ServerConnectionState.CONNECTED);
      if (!isInitial) {
        _layoutPreferenceManager.message = null;
        yield Right(LayoutEntity.empty(isEmptyState: true));
      }
      Log.d("Subscribing Layout Topic $layout", tag: _TAG);

      await _mqttRepository.subscribe(layout);

      final mqttRepository = _mqttRepository;
      yield* mqttRepository
          .getTopicMessage(layout)
          .where((event) => event.topic == currentLayout)
          .asyncMap(
            (message) => _mapToLayoutBuilder(message).then(
              (value) {
                isInitial = false;
                Log.d("New Layout for $currentLayout $value", tag: _TAG);
                _layoutPreferenceManager.message = message;
                return value;
              },
            ).catchError(_onErrorCatch),
          );
    });
  }

  Future<Either<LayoutFailure, LayoutEntity>> _onErrorCatch(
    Object error,
  ) async {
    Log.e("Layout Failure", tag: _TAG, ex: error);
    if (error is FormatException) {
      return left(const LayoutFailure.invalidLayout());
    } else {
      return left(const LayoutFailure.unexpected());
    }
  }

  Future<Either<LayoutFailure, LayoutEntity>> _mapToLayoutBuilder(
    TopicMessage message,
  ) async {
    final layout = jsonDecode(message.message) as Map<String, dynamic>;
    return Right(layoutMapper.mapToBuilder(Layout.fromJson(layout)));
  }

  @override
  Future<Unit> clearData() async {
    await _layoutPreferenceManager.clearData();
    return unit;
  }
}
