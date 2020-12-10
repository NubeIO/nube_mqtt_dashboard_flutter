import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class ValueObject<T> {
  final Option<T> value;

  const ValueObject(this.value);

  static ValueObject<String> emptyString(String input) {
    if (input == null || input.isEmpty) return ValueObject<String>.none();
    return ValueObject<String>(some(input));
  }

  T getOrCrash() {
    return value.fold(() => throw Error(), id);
  }

  T getOrElse(T dflt) {
    return value.getOrElse(() => dflt);
  }

  bool get isValid => value.isSome();

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ValueObject<T> && (o.isValid == isValid) && (o.value == value);
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '$value';

  factory ValueObject.none() => ValueObject(none());
}
