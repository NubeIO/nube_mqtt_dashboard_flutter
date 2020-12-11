import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/failure.dart';

part 'url.freezed.dart';

@freezed
abstract class UrlFailure extends Failure with _$UrlFailure {
  const factory UrlFailure.invalidUrl() = _InvalidUrl;
  const factory UrlFailure.unexpected() = _Unexpected;
}
