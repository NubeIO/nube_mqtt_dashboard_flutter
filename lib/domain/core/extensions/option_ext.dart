import 'package:dartz/dartz.dart';

import '../errors.dart';

extension OptionExt<T> on Option<T> {
  T getOrCrash() {
    return fold(() => throw UnexpectedValueError(), id);
  }
}
