import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/validation_interface.dart';
import 'failures.dart';

export 'failures.dart';

class EmailValidation extends IValidation<EmailFailure, String> {
  EmailValidation({
    @required ValidationMapper<EmailFailure> mapper,
  }) : super(mapper);
  final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Future<Either<EmailFailure, String>> validate(String input) async {
    final validEmail = regex.hasMatch(input);
    if (!validEmail) {
      return left(const EmailFailure.invalidEmail());
    } else {
      return right(input.trim());
    }
  }
}
