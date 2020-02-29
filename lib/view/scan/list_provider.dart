
import 'package:driver_app/base/base.dart';

class ListProvider extends BaseProvider {
  Set<String> _list = Set();
  ListProvider();

  Set<String> get list => _list;

  add(String value) {
    _list.add(value);
    notifyListeners();
  }

  remove(String value) {
    _list.remove(value);
    notifyListeners();
  }

  addList(List<String> l) {
    _list.addAll(l);
  }
}