import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class SuccessProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;

  SuccessProvider(this._repo);


  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  Observable logout() => _repo.logout().doOnData(
          (r) {
        LoginResponse res = LoginResponse.fromJson(r);
        if(res.result) {
          _repo.removeToken();
        }
      }
  );
}
