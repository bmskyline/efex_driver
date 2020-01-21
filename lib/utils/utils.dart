import 'package:intl/intl.dart';

String getDate() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  //return formatter.format(now);
  return "2020-01-15";
}