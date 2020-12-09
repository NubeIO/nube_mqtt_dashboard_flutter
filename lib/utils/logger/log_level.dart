import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_level.freezed.dart';

@freezed
abstract class LogLevel with _$LogLevel {
  const factory LogLevel.v() = _V;
  const factory LogLevel.d() = _D;
  const factory LogLevel.i() = _I;
  const factory LogLevel.w() = _W;
  const factory LogLevel.e() = _E;
}
