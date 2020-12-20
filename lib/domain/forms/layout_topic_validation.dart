import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/validation_interface.dart';
import 'failures/empty.dart';
import 'failures/layout_topic.dart';

class LayoutTopicValidation extends IValidation<LayoutTopicFailure, String> {
  LayoutTopicValidation({
    @required ValidationMapper<LayoutTopicFailure> mapper,
  }) : super(mapper);

  @override
  Future<Either<EmptyFailure, String>> validate(String input) async {
    final trimmedData = input.trim();
    if (trimmedData.isEmpty) {
      return left(const EmptyFailure.empty());
    } else {
      return right(trimmedData);
    }
  }
}
