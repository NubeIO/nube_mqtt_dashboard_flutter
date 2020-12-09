import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/failure.dart';

part 'length.freezed.dart';

@freezed
abstract class LengthFailure extends Failure with _$LengthFailure {
  const factory LengthFailure.invalidLength() = _InvalidLength;
}
