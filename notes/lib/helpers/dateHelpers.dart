import 'package:intl/intl.dart';

String getFormattedDate() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd - kk:mm').format(now);
}

String getFormattedDateShorterSyntax() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

String formatDate(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

String formatToShorterDate(String date) {
  return date.substring(0, 10);
}
