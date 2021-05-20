import '../core/interfaces/datasource.dart';
import 'entities.dart';

export 'entities.dart';

abstract class IConfigurationDataSource extends IDataSource {
  Future<Configuration> fetchConnectionConfig();

  Future<TopicConfiguration> fetchTopicConfig();
}
