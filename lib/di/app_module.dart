import 'package:dartin/dartin.dart';
import 'package:dio/dio.dart';
import 'package:driver_app/data/repository.dart';
import 'package:driver_app/utils/shared_preferences_utils.dart';
import 'package:driver_app/view/detail/detail_provider.dart';
import 'package:driver_app/view/home/home_provider.dart';
import 'package:driver_app/view/home/pickup/pickup_provider.dart';
import 'package:driver_app/view/home/return/return_provider.dart';
import 'package:driver_app/view/login/login_provider.dart';
import 'package:driver_app/view/order_detail/order_detail_provider.dart';
import 'package:driver_app/view/order_list/order_list_provider.dart';
import 'package:driver_app/view/scan/list_provider.dart';
import 'package:driver_app/view/scan/scan_provider.dart';

const testScope = DartInScope('test');

final viewModelModule = Module([
  factory<LoginProvider>(({params}) => LoginProvider(get())),
  single<PickupProvider>(({params}) => PickupProvider(get())),
  single<ReturnProvider>(({params}) => ReturnProvider(get())),
  single<HomeProvider>(({params}) => HomeProvider(get(), get())),
  factory<DetailProvider>(({params}) => DetailProvider(get())),
  factory<OrderDetailProvider>(({params}) => OrderDetailProvider(get(), get())),
  factory<OrderListProvider>(({params}) => OrderListProvider(get(), get())),
  factory<ScanProvider>(({params}) => ScanProvider()),
  factory<ListProvider>(({params}) => ListProvider()),
])
  ..withScope(testScope, [
    ///other scope
    //factory<HomeProvider>(({params}) => HomeProvider()),
  ]);

final repoModule = Module([
  single<GithubRepo>(({params}) => GithubRepo(get(), get())),
]);

final remoteModule = Module([
  single<GithubService>(({params}) => GithubService()),
]);

final localModule = Module([
  single<SpUtil>(({params}) => spUtil),
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
      baseUrl: 'https://apimobile.efex.vn/api/v1/',
      connectTimeout: 30,
      receiveTimeout: 30)
  ..interceptors.add(AuthInterceptor())
  ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

SpUtil spUtil;

init() async {
  spUtil = await SpUtil.getInstance();
  startDartIn(appModule);
}
