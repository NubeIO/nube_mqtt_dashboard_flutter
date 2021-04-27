class DateUtils {
  /// Get ISO time String from DateTime
  /// Output: 2020-09-16T20:42:38.629+05:30
  static String getISOTimeString({DateTime dateTime}) {
    final date = dateTime ?? DateTime.now();
    // Time zone may be null in dateTime hence get timezone by datetime
    final duration = DateTime.now().timeZoneOffset;
    if (duration.isNegative) {
      return "${date.toIso8601String()}${"-${duration.inHours.abs().toString().padLeft(2, '0')}:${(duration.inMinutes.abs() - (duration.inHours.abs() * 60)).toString().padLeft(2, '0')}"}";
    } else {
      return "${date.toIso8601String()}${"+${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}"}";
    }
  }
}
