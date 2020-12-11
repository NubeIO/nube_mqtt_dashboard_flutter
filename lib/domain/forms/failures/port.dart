import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/failure.dart';

part 'port.freezed.dart';

@freezed
abstract class PortFailure extends Failure with _$PortFailure {
  const factory PortFailure.invalidPort() = _InvalidPort;
  const factory PortFailure.unexpected() = _Unexpected;
  const factory PortFailure.noNumber() = _NotNumber;
}
