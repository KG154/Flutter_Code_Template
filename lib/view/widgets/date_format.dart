import 'package:intl/intl.dart';

String dateTimeFormat(String? date, {bool? withTime = false}) {
  return DateFormat(withTime == true ? 'dd MMM yyyy, hh:mm a' : 'dd MMM yyyy')
      .format(DateTime.parse(date.toString()).toUtc().toLocal());
}