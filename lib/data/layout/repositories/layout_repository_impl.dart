import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../constants/app_constants.dart';
import '../../../domain/layout/layout_repository_interface.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../mappers/layout.dart';
import '../models/layout.dart';

@LazySingleton(as: ILayoutRepository)
class LayoutRepositoryImpl extends ILayoutRepository {
  final IMqttRepository _mqttRepository;

  LayoutRepositoryImpl(this._mqttRepository) {
    _mqttRepository.subscribe(AppConstants.LAYOUT_TOPIC);
  }

  final layoutMapper = LayoutMapper();

  @override
  Stream<Either<LayoutFailure, LayoutBuilder>> get layoutStream {
    return _mqttRepository.getTopicMessage(AppConstants.LAYOUT_TOPIC).asyncMap(
        (message) => _mapToLayoutBuilder(message).catchError(_onErrorCatch));
  }

  Future<Either<LayoutFailure, LayoutBuilder>> _onErrorCatch(
    Object error,
  ) async {
    if (error is FormatException) {
      return left(const LayoutFailure.invalidLayout());
    } else {
      return left(const LayoutFailure.unexpected());
    }
  }

  Future<Either<LayoutFailure, LayoutBuilder>> _mapToLayoutBuilder(
    TopicMessage message,
  ) async {
    final layout = jsonDecode(message.message) as Map<String, dynamic>;
    return Right(layoutMapper.mapToBuilder(Layout.fromJson(layout)));
  }
}
