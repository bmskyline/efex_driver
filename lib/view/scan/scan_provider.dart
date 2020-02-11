import 'package:driver_app/base/base.dart';

class ScanProvider extends BaseProvider {
  bool _loading = false;
  Set<String> _list = Set();
  Set<String> _alreadyScan = Set();

  ScanProvider();

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Set<String> getList() => _list;

  set list(String value) {
    _list.add(value);
    notifyListeners();
  }

  Set<String> getListScan() => _alreadyScan;

  set alreadyScan(String value) {
    _alreadyScan.add(value);
  }

  addList(List<String> l) {
    _list.addAll(l);
  }
}
