import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';

import '../core/interfaces/data_repository.dart';
import 'entities.dart';
import 'failures.dart';

export 'package:dartz/dartz.dart';

export '../core/interfaces/data_repository.dart';
export 'entities.dart';
export 'failures.dart';

abstract class ISiteRepository implements IDataRepository {
  Future<Either<GetSiteFailure, KtList<Site>>> fetchSites();
  Future<Either<SetSiteFailure, Unit>> setSite(String uuid);
  Stream<Either<SiteFailure, KtList<Site>>> get sitesStream;
  Stream<Either<SiteFailure, Site>> get activeSiteStream;
}
