part of entities;

@freezed
abstract class LogItem with _$LogItem {
  const factory LogItem({
    @required String title,
    @required String message,
    @required String detail,
    @required LogLevel logLevel,
    @required DateTime date,
  }) = _LogItem;
}
