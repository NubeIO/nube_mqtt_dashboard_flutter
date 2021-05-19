import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../application/validation/value_object.dart';
import '../core/validation_interface.dart';
import 'failures.dart';

export 'failures.dart';

class PasswordValidation extends IValidation<PasswordFailure, String> {
  final ValueObject<String> Function() _previousPassword;
  static final digitRegex = RegExp('[0-9]');
  static final upperCharRegex = RegExp('[A-Z]');

  PasswordValidation({
    @required ValidationMapper<PasswordFailure> mapper,
    ValueObject<String> Function() previousPassword,
  })  : _previousPassword = previousPassword,
        super(mapper);

  @override
  Future<Either<PasswordFailure, String>> validate(String input) async {
    if (input.length < 8) {
      return left(const PasswordFailure.tooShort());
    } else if (!input.contains(digitRegex)) {
      return left(const PasswordFailure.noDigit());
    } else if (!input.contains(upperCharRegex)) {
      return left(const PasswordFailure.noUpperChar());
    } else if (_previousPassword != null) {
      return _previousPassword().value.fold(
          () => left(const PasswordFailure.passwordMismatch()),
          (password) => password == input
              ? right(input.trim())
              : left(const PasswordFailure.passwordMismatch()));
    } else {
      return right(input.trim());
    }
  }
}
