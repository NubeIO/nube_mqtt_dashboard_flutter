import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/failure.dart';

part 'layout_topic.freezed.dart';

@freezed
abstract class LayoutTopicFailure extends Failure with _$LayoutTopicFailure {
  const factory LayoutTopicFailure.empty() = _Empty;
}
