import 'package:injectable/injectable.dart';

import '../../../data/network/dio_error_extension.dart';
import '../../../domain/network/api_data_source_interface.dart';
import '../../../domain/site/site_data_source_interface.dart';
import '../mappers/site_mapper.dart';

@LazySingleton(as: ISiteDataSource)
class SiteDataSourceImpl extends ISiteDataSource {
  final IApiDataSource _apiRepository;

  final SiteMapper _siteMapper = SiteMapper();
  SiteDataSourceImpl(this._apiRepository);

  @override
  Future<KtList<Site>> getSites() {
    return _apiRepository.siteApi
        .then((api) => api.getSites())
        .then((response) => _siteMapper.toSites(response))
        .catchDioException();
  }
}
