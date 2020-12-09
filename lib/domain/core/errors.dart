class UnexpectedValueError extends Error {
  static const explanation =
      'Encountered a unexpected value at an unrecoverable point.';

  @override
  String toString() {
    return Error.safeToString(explanation);
  }
}
