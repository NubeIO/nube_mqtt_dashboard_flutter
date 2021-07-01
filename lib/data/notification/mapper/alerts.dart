import 'package:kt_dart/kt.dart';

import '../../../domain/notifications/entities.dart';
import '../../../domain/site/entities.dart';
import '../models/alerts.dart';

class AlertMapper {
  AlertEntity mapToAlerts(Alerts alerts, Site site) {
    return AlertEntity(
      alerts: alerts.alerts
          .map((alert) => mapToAlert(alert, site))
          .toImmutableList(),
    );
  }

  Alert mapToAlert(AlertResponse alert, Site site) {
    return Alert(
      timestamp: DateTime.fromMillisecondsSinceEpoch(alert.timestamp),
      title: alert.title,
      subtitle: alert.subtitle,
      alertType: alert.alertType,
      site: site,
      priority: mapToPriority(alert.priority),
    );
  }

  Priority mapToPriority(PriorityResponse priority) {
    switch (priority) {
      case PriorityResponse.HIGH:
        return const Priority.high();
      case PriorityResponse.NORMAL:
        return const Priority.normal();
      case PriorityResponse.LOW:
        return const Priority.low();
    }
    return const Priority.low();
  }

  Alerts mapFromAlerts(AlertEntity alertEntity) {
    return Alerts(
      alerts: alertEntity.alerts
          .asList()
          .map((alert) => mapFromAlert(alert))
          .toList(),
    );
  }

  AlertResponse mapFromAlert(Alert alert) {
    return AlertResponse(
      timestamp: alert.timestamp.millisecondsSinceEpoch,
      title: alert.title,
      subtitle: alert.subtitle,
      alertType: alert.alertType,
      siteId: alert.site?.uuid,
      priority: mapFromPriority(alert.priority),
    );
  }

  PriorityResponse mapFromPriority(Priority priority) {
    return priority.when(
      high: () => PriorityResponse.HIGH,
      normal: () => PriorityResponse.NORMAL,
      low: () => PriorityResponse.LOW,
    );
  }
}
