import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class FormOption {
  final String label;
  final String id;
  const FormOption({
    @required this.id,
    @required this.label,
  });

  @override
  bool operator ==(dynamic other) {
    return other is FormOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
