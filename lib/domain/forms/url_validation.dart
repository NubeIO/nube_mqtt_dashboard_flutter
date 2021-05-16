import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/validation_interface.dart';
import 'failures.dart';

export 'failures.dart';

class UrlValidation extends IValidation<UrlFailure, String> {
  UrlValidation({
    @required ValidationMapper<UrlFailure> mapper,
  }) : super(mapper);
  static final regex = RegExp(
      r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)',
      caseSensitive: false);
  @override
  Future<Either<UrlFailure, String>> validate(String input) async {
    try {
      Uri();
      final trimmedInput = input.trim();
      final validUrl = regex.hasMatch(trimmedInput);
      if (!validUrl) {
        return left(const UrlFailure.invalidUrl());
      } else {
        return right(trimmedInput);
      }
    } catch (e) {
      return const Left(UrlFailure.unexpected());
    }
  }
}
