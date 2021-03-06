import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/validation_interface.dart';
import 'failures/port.dart';

class PortValidation extends IValidation<PortFailure, int> {
  PortValidation({
    @required ValidationMapper<PortFailure> mapper,
  }) : super(mapper);
  static final regex = RegExp(
      r"^(102[4-9]|10[3-9]\d|1[1-9]\d{2}|[2-9]\d{3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$");
  @override
  Future<Either<PortFailure, int>> validate(String input) async {
    try {
      final output = int.parse(input?.trim());
      final validPort = regex.hasMatch(input);
      if (!validPort) {
        return left(const PortFailure.invalidPort());
      } else {
        return right(output);
      }
    } on FormatException {
      return const Left(PortFailure.noNumber());
    } catch (e) {
      return const Left(PortFailure.unexpected());
    }
  }
}
