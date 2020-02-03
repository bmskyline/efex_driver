import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/data/repository.dart';

class ScanProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  Set<Order> _list = Set();

  ScanProvider(this._repo);


  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Set<Order> getList() => _list;

  set list(Order value) {
    _list.add(value);
    notifyListeners();
  }

  addList(List<Order> l) {
    _list.addAll(l);
  }

}
