import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/configuration/configuration_repository_interface.dart';
import '../../../domain/mqtt/mqtt_repository.dart';
import '../../../domain/notifications/entities.dart';
import '../../../domain/notifications/notification_data_source_interface.dart';
import '../../../domain/notifications/notification_repository_interface.dart';
import '../../../domain/site/site_repository_interface.dart';
import '../../../utils/logger/log.dart';
import '../managers/alerts_data_preference.dart';
import '../mapper/alerts.dart';
import '../models/alerts.dart';

const _TAG = "NotificationRepository";

@LazySingleton(as: INotificationRepository)
class NotificationRepositoryImpl extends INotificationRepository {
  final INotificationDataSource _notificationDataSource;
  final IMqttRepository _mqttRepository;
  final IConfigurationRepository _configurationRepository;
  final AlertsPreferenceManager _alertsPreferenceManager;
  final ISiteRepository _siteRepository;

  NotificationRepositoryImpl(
    this._notificationDataSource,
    this._mqttRepository,
    this._configurationRepository,
    this._alertsPreferenceManager,
    this._siteRepository,
  );

  final alertMapper = AlertMapper();

  @override
  Future<Either<GetTokenFailure, String>> getToken() async {
    try {
      final token = await _notificationDataSource.getToken();
      if (token.isNotEmpty) {
        return Right(token);
      }
      return const Left(GetTokenFailure.empty());
    } catch (e) {
      return const Left(GetTokenFailure.unexpected());
    }
  }

  @override
  Stream<Either<TokenStreamFailure, String>> get tokenStream async* {
    yield* _notificationDataSource.tokenStream
        .handleError((error) => const Left(TokenStreamFailure.unexpected()))
        .map((event) => Right(event));
  }

  @override
  Stream<Either<AlertFailure, AlertEntity>> get alertStream async* {
    final message = _alertsPreferenceManager.alerts;
    if (message != null) {
      final result = await _mapToAlertBuilder(message, null);
      if (result.isRight()) {
        yield result.fold(
          (l) => throw AssertionError(),
          (alerts) => Right(alerts),
        );
      }
    } else {
      yield Right(AlertEntity.empty());
    }

    yield* _configurationRepository.alertTopicStream
        .flatMap((alertSiteTopics) async* {
      await _mqttRepository.connectionStream
          .firstWhere((element) => element == ServerConnectionState.CONNECTED);

      final List<Stream<Either<AlertFailure, AlertEntity>>> streams = [];

      for (final alertSiteTopic in alertSiteTopics.iter) {
        final alertTopic = alertSiteTopic.topic;
        final alertSiteId = alertSiteTopic.siteId;
        await _mqttRepository.subscribe(alertTopic);
        final stream = _mqttRepository.getTopicMessage(alertTopic).asyncMap(
              (message) =>
                  _mapToAlertBuilderFromTopicMessage(message, alertSiteId)
                      .catchError(_onErrorCatch),
            );
        streams.add(stream);
      }

      yield* Rx.combineLatest<Either<AlertFailure, AlertEntity>,
          Either<AlertFailure, AlertEntity>>(
        streams,
        (values) {
          if (values.every((element) => element.isLeft())) {
            return const Left(AlertFailure.invalidAlert());
          }
          final KtList<Alert> alerts = values
              .map((e) => e.fold(
                    (l) => const KtList<Alert>.empty(),
                    (entry) => entry.alerts,
                  ))
              .reduce(
                (KtList<Alert> value, KtList<Alert> element) =>
                    element.toMutableList()..addAll(value),
              );
          final alertEntity = AlertEntity(alerts: alerts);
          _alertsPreferenceManager.alerts =
              alertMapper.mapFromAlerts(alertEntity);
          return Right(alertEntity);
        },
      );
    });
  }

  @override
  Stream<Either<NotificationFailure, NotificationData>> get notificaitonStream {
    return _notificationDataSource.notificationStream
        .handleError((error) => const Left(NotificationFailure.unexpected()))
        .map((event) => Right(event));
  }

  Future<Either<AlertFailure, AlertEntity>> _onErrorCatch(
    Object error,
  ) async {
    Log.e("Alert Failure", tag: _TAG, ex: error);
    if (error is FormatException) {
      return Right(AlertEntity.empty());
    } else {
      return const Left(AlertFailure.unexpected());
    }
  }

  Future<Either<AlertFailure, AlertEntity>> _mapToAlertBuilder(
    Alerts input,
    @nullable String siteId,
  ) async {
    final List<Alert> alerts = await Stream.fromIterable(
      input.alerts,
    ).asyncMap((alert) async {
      if (alert.siteId == null && siteId == null) {
        return alertMapper.mapToAlert(alert, null);
      }
      final siteResult = await _siteRepository.getSite(siteId ?? alert.siteId);
      return alertMapper.mapToAlert(alert, siteResult.fold((l) => null, id));
    }).toList();

    return Right(AlertEntity(
      alerts: alerts.toImmutableList(),
    ));
  }

  Future<Either<AlertFailure, AlertEntity>> _mapToAlertBuilderFromTopicMessage(
    TopicMessage message,
    @nullable String siteId,
  ) async {
    final layout = jsonDecode(message.message) as Map<String, dynamic>;
    final input = Alerts.fromJson(layout);

    return _mapToAlertBuilder(input, siteId);
  }

  @override
  Future<Unit> clearData() async {
    await _alertsPreferenceManager.clearData();
    return unit;
  }
}
