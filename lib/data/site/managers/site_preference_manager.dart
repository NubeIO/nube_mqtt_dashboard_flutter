import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/core/interfaces/managers.dart';
import '../../../domain/site/entities.dart';
import '../datasources/models/responses.dart';
import '../mappers/site_mapper.dart';

@injectable
class SitePreferenceManager extends IManager {
  final SharedPreferences _sharedPreferences;
  final SiteMapper _siteMapper = SiteMapper();

  SitePreferenceManager(this._sharedPreferences);

  KtList<Site> get sites {
    final message = _sharedPreferences.getString(_Model.sites.key) ?? "";
    if (message.isEmpty) return null;
    try {
      final map = jsonDecode(message) as List<Map<String, dynamic>>;
      return _siteMapper.toSites(
        map.map((e) => SiteResponse.fromJson(e)).toList(),
      );
    } catch (e) {
      return const KtList.empty();
    }
  }

  set active(Site site) {
    _sharedPreferences.setString(
      _Model.active.key,
      jsonEncode(_siteMapper.mapFromSite(site).toJson()),
    );
  }

  Site get active {
    final message = _sharedPreferences.getString(_Model.active.key) ?? "";
    if (message.isEmpty) return null;
    final map = jsonDecode(message) as Map<String, dynamic>;
    return _siteMapper.toSite(SiteResponse.fromJson(map));
  }

  set sites(KtList<Site> sites) {
    _sharedPreferences.setString(
      _Model.sites.key,
      jsonEncode(_siteMapper.mapFromSites(sites)),
    );
  }

  @override
  Future<Unit> clearData() async {
    _Model.values.forEach(_removeItem);
    return unit;
  }

  void _removeItem(_Model model) {
    _sharedPreferences.remove(model.key);
  }
}

enum _Model { sites, active }

extension on _Model {
  String get key {
    switch (this) {
      case _Model.sites:
        return "key:site:sites";
      case _Model.active:
        return "key:site:active";
    }
    return "";
  }
}
