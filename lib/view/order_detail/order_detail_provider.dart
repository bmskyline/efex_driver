import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/repository.dart';

class OrderDetailProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  OrderDetailProvider(this._repo);

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
