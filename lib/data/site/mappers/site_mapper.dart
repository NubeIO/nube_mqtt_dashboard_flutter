import 'package:kt_dart/kt.dart';

import '../../../domain/site/entities.dart';
import '../datasources/models/responses.dart';

class SiteMapper {
  KtList<Site> toSites(List<SiteResponse> response) {
    return response.map((e) => toSite(e)).toImmutableList();
  }

  Site toSite(SiteResponse response) {
    return Site(
      uuid: response.uuid,
      name: defaultSiteName(response.name, response.uuid),
      address: response.address ?? "",
      city: response.city ?? "",
      state: response.state ?? "",
      zip: response.zip,
      country: response.country ?? "",
      latitude: response.latitude,
      longitude: response.longitude,
      timeZone: response.timeZone,
    );
  }

  List<SiteResponse> mapFromSites(KtList<Site> sites) {
    return sites.map((e) => mapFromSite(e)).asList();
  }

  SiteResponse mapFromSite(Site site) {
    return SiteResponse(
      uuid: site.uuid,
      name: defaultSiteName(site.name, site.uuid),
      address: site.address ?? "",
      city: site.city ?? "",
      state: site.state ?? "",
      zip: site.zip,
      country: site.country ?? "",
      latitude: site.latitude,
      longitude: site.longitude,
      timeZone: site.timeZone,
    );
  }

  String defaultSiteName(String name, String uuid) =>
      name == null || name.isEmpty
          ? "Site ${uuid.substring(uuid.length - 5)}"
          : name;
}
