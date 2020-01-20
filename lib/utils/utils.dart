import 'package:intl/intl.dart';

String getDate() {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  //return formatter.format(now);
  return "2020-01-15";
}