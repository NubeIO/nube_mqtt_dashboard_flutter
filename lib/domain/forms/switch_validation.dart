import 'package:dartz/dartz.dart';

import '../core/validation_interface.dart';

export 'failures.dart';

class SwitchValidation extends IValidation<Failure, bool> {
  SwitchValidation() : super((_) => "");

  @override
  Future<Either<Failure, bool>> validate(bool input) async {
    return right(input);
  }
}
