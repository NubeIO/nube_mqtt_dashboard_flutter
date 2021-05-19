import 'package:injectable/injectable.dart';

import '../../../domain/notifications/alerts_data_source_interface.dart';

@LazySingleton(as: IAlertsDataSource)
class NetworkAlertsDataSource extends IAlertsDataSource {
  NetworkAlertsDataSource();
}
