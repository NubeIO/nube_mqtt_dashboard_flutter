import 'package:dartz/dartz.dart';

import '../mqtt/entities.dart';
import 'entities.dart';
import 'failures.dart';

export 'entities.dart';
export 'failures.dart';

abstract class IWidgetDataRepository {
  Future<Either<SubscribeFailure, Unit>> subscribeWidget(String topic);

  Stream<Either<SubscriptionStateFailure, MqttSubscriptionState>>
      getSubscriptionState(String topic);

  Stream<Either<WidgetDataSubscribeFailure, WidgetData>> getWidgetUpdates(
      String topic);

  Future<Either<WidgetSetFailure, Unit>> setData(
      String topic, WidgetData value);
}
