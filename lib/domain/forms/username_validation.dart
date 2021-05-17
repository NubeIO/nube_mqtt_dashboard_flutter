import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/validation_interface.dart';
import 'failures.dart';

export 'failures.dart';

class UsernameValidation extends IValidation<UsernameFailure, String> {
  UsernameValidation({
    @required ValidationMapper<UsernameFailure> mapper,
  }) : super(mapper);

  @override
  Future<Either<UsernameFailure, String>> validate(String input) async {
    if (input.length < 8) {
      return left(const UsernameFailure.tooShort());
    } else {
      return right(input.trim());
    }
  }
}
