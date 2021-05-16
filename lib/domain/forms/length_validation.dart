import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/validation_interface.dart';
import 'failures.dart';

export 'failures.dart';

class LengthValidation extends IValidation<LengthFailure, String> {
  final int length;

  LengthValidation({
    @required this.length,
    @required ValidationMapper<LengthFailure> mapper,
  }) : super(mapper);

  @override
  Future<Either<LengthFailure, String>> validate(String input) async {
    final output = input?.trim() ?? "";
    if (output.length != length) {
      return left(const LengthFailure.invalidLength());
    } else {
      return right(output);
    }
  }
}
