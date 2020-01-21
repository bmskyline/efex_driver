import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/repository.dart';

class ScanProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  Set<String> _list = Set();

  ScanProvider(this._repo);


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


}
