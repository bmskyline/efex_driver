import 'package:dartin/dartin.dart';
import 'package:dio/dio.dart';
import 'package:driver_app/data/repository.dart';
import 'package:driver_app/utils/shared_preferences_utils.dart';
import 'package:driver_app/view/detail/detail_provider.dart';
import 'package:driver_app/view/home/cancel/cancel_provider.dart';
import 'package:driver_app/view/home/home_provider.dart';
import 'package:driver_app/view/home/new/new_provider.dart';
import 'package:driver_app/view/home/pickup/pickup_provider.dart';
import 'package:driver_app/view/home/return/return_provider.dart';
import 'package:driver_app/view/home/success/success_provider.dart';
import 'package:driver_app/view/login/login_provider.dart';
import 'package:driver_app/view/order_detail/order_detail_provider.dart';
import 'package:driver_app/view/order_list/order_list_provider.dart';
import 'package:driver_app/view/scan/scan_provider.dart';

const testScope = DartInScope('test');

final viewModelModule = Module([
  factory<LoginProvider>(({params}) => LoginProvider(get())),
  lazy<NewProvider>(({params}) => NewProvider(get())),
  lazy<SuccessProvider>(({params}) => SuccessProvider(get())),
  lazy<CancelProvider>(({params}) => CancelProvider(get())),
  lazy<PickupProvider>(({params}) => PickupProvider(get())),
  lazy<ReturnProvider>(({params}) => ReturnProvider(get())),
  factory<HomeProvider>(({params}) => HomeProvider()),
  factory<DetailProvider>(({params}) => DetailProvider(get())),
  factory<OrderDetailProvider>(({params}) => OrderDetailProvider(get())),
  factory<OrderListProvider>(({params}) => OrderListProvider(get())),
  factory<ScanProvider>(({params}) => ScanProvider(get())),
])
  ..addOthers(testScope, [
    ///other scope
    //factory<HomeProvider>(({params}) => HomeProvider()),
  ]);

final repoModule = Module([
  lazy<GithubRepo>(({params}) => GithubRepo(get(), get())),
]);

final remoteModule = Module([
  single<GithubService>(GithubService()),
]);

final localModule = Module([
  single<SpUtil>(spUtil),
]);

final appModule = [viewModelModule, repoModule, remoteModule, localModule];

class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    final token = spUtil.getString("TOKEN");
    options.headers.update("x-token", (_) => token, ifAbsent: () => token);
    return super.onRequest(options);
  }
}

final dio = Dio()
  ..options = BaseOptions(
      baseUrl: 'https://apimobiletest.efex.vn/api/v1/',
      connectTimeout: 30,
      receiveTimeout: 30)
  ..interceptors.add(AuthInterceptor())
  ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

SpUtil spUtil;

init() async {
  spUtil = await SpUtil.getInstance();
  startDartIn(appModule);
}
