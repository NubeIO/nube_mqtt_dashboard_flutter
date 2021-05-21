import 'package:kt_dart/kt.dart';

import '../../../domain/notifications/entities.dart';
import '../models/alerts.dart';

class AlertMapper {
  AlertEntity mapToAlerts(Alerts alerts) {
    return AlertEntity(
      alerts: alerts.alerts.map((alert) => mapToAlert(alert)).toImmutableList(),
    );
  }

  Alert mapToAlert(AlertResponse alert) {
    return Alert(
      timestamp: DateTime.fromMillisecondsSinceEpoch(alert.timestamp),
      title: alert.title,
      subtitle: alert.subtitle,
      alertType: alert.alertType,
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
}
