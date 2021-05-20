import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nube_mqtt_dashboard/domain/user/user_repository_interface.dart';
import 'package:nube_mqtt_dashboard/injectable/injection.dart';

import '../core/validation_interface.dart';
import 'failures.dart';

export 'failures.dart';

class EmailValidation extends IValidation<EmailFailure, String> {
  final IUserRepository _userRepository = getIt<IUserRepository>();

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
      final username = input.trim();
      final usernameResult = await _userRepository.checkEmail(username);
      return usernameResult.fold(
        (l) => left(l.when(
          userExists: () => const EmailFailure.emailTaken(),
          connection: () => const EmailFailure.connection(),
          server: () => const EmailFailure.server(),
          unexpected: () => const EmailFailure.unexpected(),
        )),
        (r) => right(username),
      );
    }
  }
}
