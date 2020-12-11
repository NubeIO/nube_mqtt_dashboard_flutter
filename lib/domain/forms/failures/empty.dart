import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/failure.dart';

part 'empty.freezed.dart';

@freezed
abstract class EmptyFailure extends Failure with _$EmptyFailure {
  const factory EmptyFailure.empty() = _Empty;
}
