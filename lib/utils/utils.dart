import 'package:intl/intl.dart';

String getDate() {
  var now = DateTime.now();
  final todayNoon = new DateTime(now.year, now.month, now.day, 12);
  var formatter = DateFormat('yyyy-MM-dd');
  /*if(now.isBefore(todayNoon)) {
    return formatter.format(now)+" 09:00:00";
  } else return formatter.format(now) + " 14:00:00";*/
  return "2020-01-15 14:00:00";
}