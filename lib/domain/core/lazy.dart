class Lazy<T> {
  final Function _func;
  bool _isEvaluated = false;
  T _value;
  Lazy(this._func);
  T call() {
    if (!_isEvaluated) {
      if (_func != null) {
        _value = _func() as T;
      }
      _isEvaluated = true;
    }
    return _value;
  }
}
