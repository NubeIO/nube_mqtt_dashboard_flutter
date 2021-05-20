import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nube_mqtt_dashboard/domain/user/user_repository_interface.dart';
import 'package:nube_mqtt_dashboard/injectable/injection.dart';

import '../core/validation_interface.dart';
import 'failures.dart';

export 'failures.dart';

class UsernameValidation extends IValidation<UsernameFailure, String> {
  final IUserRepository _userRepository = getIt<IUserRepository>();
  UsernameValidation({
    @required ValidationMapper<UsernameFailure> mapper,
  }) : super(mapper);

  @override
  Future<Either<UsernameFailure, String>> validate(String input) async {
    if (input.length < 8) {
      return left(const UsernameFailure.tooShort());
    } else {
      final username = input.trim();
      final usernameResult = await _userRepository.checkUsername(username);
      return usernameResult.fold(
        (l) => left(l.when(
          userExists: () => const UsernameFailure.usernameTaken(),
          connection: () => const UsernameFailure.connection(),
          server: () => const UsernameFailure.server(),
          unexpected: () => const UsernameFailure.unexpected(),
        )),
        (r) => right(username),
      );
    }
  }
}
