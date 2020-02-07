import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/data/model/shop_detail_response.dart';
import 'package:driver_app/data/model/shop_response.dart';
import 'package:driver_app/data/model/status.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:driver_app/view/home/pickup/pickup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PickupPage extends PageProvideNode<PickupProvider> {
  final BuildContext homeContext;
  final String status;
  PickupPage(this.homeContext, this.status);

  @override
  Widget buildContent(BuildContext context) {
    return _PickupContentPage(homeContext, mProvider, status);
  }
}

class _PickupContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final PickupProvider provider;
  final String status;
  _PickupContentPage(this.homeContext, this.provider, this.status);

  @override
  State<StatefulWidget> createState() {
    return _PickupContentState(homeContext, status);
  }
}

class _PickupContentState extends State<_PickupContentPage>
    with
        TickerProviderStateMixin<_PickupContentPage>,
        AutomaticKeepAliveClientMixin {
  BuildContext homeContext;
  String status;

  _PickupContentState(this.homeContext, this.status);

  PickupProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    switch(status) {
      case "new":
        mProvider.shopsNew = List();
        mProvider.pageNew = 0;
        mProvider.totalNew = 0;
        break;
      case "picked":
        mProvider.shopsSuccess = List();
        mProvider.pageSuccess = 0;
        mProvider.totalSuccess = 0;
        break;
      case "fail":
        mProvider.shopsCancel = List();
        mProvider.pageCancel = 0;
        mProvider.totalCancel = 0;
        break;
    }
  }

  void _loadData() {
    final s = mProvider
        .getShops(status)
        .doOnListen(() {})
        .doOnDone(() {})
        .listen((data) {
      //success
      ShopResponse response = ShopResponse.fromJson(data);
      if(!response.result) {
        if(response.msg == "user not authorized") {
          mProvider.logout();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);

        }
      }
    }, onError: (e) {
      //error
      dispatchFailure(context, e);
    });
    mProvider.addSubscription(s);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (status == "new") {
            if (!mProvider.loading &&
                mProvider.pageNew * mProvider.limit < mProvider.totalNew &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadData();
            }
          } else if (status == "picked") {
            if (!mProvider.loading &&
                mProvider.pageSuccess * mProvider.limit <
                    mProvider.totalSuccess &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadData();
            }
          } else {
            if (!mProvider.loading &&
                mProvider.pageCancel * mProvider.limit <
                    mProvider.totalCancel &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadData();
            }
          }
        },
        child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          Consumer<PickupProvider>(builder: (context, value, child) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Container(
                color: primaryColorHome,
                child: ListView.builder(
                  itemCount: status == "new"
                      ? (value.shopsNew == null ? 0 : value.shopsNew.length)
                      : (status == "picked"
                          ? (value.shopsSuccess == null
                              ? 0
                              : value.shopsSuccess.length)
                          : (value.shopsCancel == null
                              ? 0
                              : value.shopsCancel.length)),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      child: Card(
                        margin: EdgeInsets.all(0.5),
                        color: secondColorHome,
                        child: InkWell(
                          onTap: () async {
                            switch (status) {
                              case "new":
                                if (value.shopsNew[index].isActive) {
                                  final res = await Navigator.push(
                                      homeContext,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              value.shopsNew[index],
                                              status,
                                              1)));
                                  print("data day" +res.toString());
                                  if (res != null &&
                                      res as String == "refresh") {
                                    print("vao day ro");
                                    mProvider.shopsNew = List();
                                    mProvider.pageNew = 0;
                                    mProvider.totalNew = 0;
                                    _loadData();
                                  }
                                }
                                break;
                              case "picked":
                                Navigator.push(
                                    homeContext,
                                    MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            value.shopsSuccess[index],
                                            status,
                                            1)));
                                break;
                              case "fail":
                                Navigator.push(
                                    homeContext,
                                    MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            value.shopsCancel[index],
                                            status,
                                            1)));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          status == "new"
                                              ? value.shopsNew[index].fromName +
                                                  " (" +
                                                  value.shopsNew[index]
                                                      .totalOrders +
                                                  ")"
                                              : (status == "picked"
                                                  ? value.shopsSuccess[index]
                                                          .fromName +
                                                      " (" +
                                                      value.shopsSuccess[index]
                                                          .totalOrders +
                                                      ")"
                                                  : value.shopsCancel[index]
                                                          .fromName +
                                                      " (" +
                                                      value.shopsCancel[index]
                                                          .totalOrders +
                                                      ")"),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: 8),
                                        Row(children: <Widget>[
                                          Icon(Icons.location_on,
                                              size: 18, color: Colors.white60),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              status == "new"
                                                  ? value.shopsNew[index]
                                                      .fromAddress
                                                  : (status == "picked"
                                                      ? value
                                                          .shopsSuccess[index]
                                                          .fromAddress
                                                      : value.shopsCancel[index]
                                                          .fromAddress),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white60),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ]),
                                        SizedBox(height: 8),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.phone,
                                                size: 18,
                                                color: Colors.white60),
                                            SizedBox(width: 16),
                                            InkWell(
                                              onTap: () => launch("tel://" +
                                                  value.shopsNew[index]
                                                      ?.fromPhone),
                                              child: Text(
                                                status == "new"
                                                    ? value.shopsNew[index]
                                                        .fromPhone
                                                    : (status == "picked"
                                                        ? value
                                                            .shopsSuccess[index]
                                                            .fromPhone
                                                        : value
                                                            .shopsCancel[index]
                                                            .fromPhone),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blueAccent,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.border_color,
                                                size: 18,
                                                color: Colors.white60),
                                            SizedBox(width: 16),
                                            Text(
                                              status == "new"
                                                  ? value.shopsNew[index]
                                                          .totalOrders
                                                          .toString() +
                                                      " đơn hàng - nặng " +
                                                      value.shopsNew[index]
                                                          .totalWeight +
                                                      "g"
                                                  : (status == "picked"
                                                      ? value
                                                              .shopsSuccess[
                                                                  index]
                                                              .totalOrders
                                                              .toString() +
                                                          " đơn hàng - nặng " +
                                                          value
                                                              .shopsSuccess[
                                                                  index]
                                                              .totalWeight +
                                                          "g"
                                                      : value.shopsCancel[index]
                                                              .totalOrders
                                                              .toString() +
                                                          " đơn hàng - nặng " +
                                                          value
                                                              .shopsCancel[
                                                                  index]
                                                              .totalWeight +
                                                          "g"),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white60),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.access_time,
                                                size: 18,
                                                color: Colors.white60),
                                            SizedBox(width: 16),
                                            Text(
                                              status == "new"
                                                  ? value
                                                      .shopsNew[index].fullCount
                                                  : (status == "picked"
                                                      ? value
                                                          .shopsSuccess[index]
                                                          .fullCount
                                                      : value.shopsCancel[index]
                                                          .fullCount),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white60),
                                            )
                                          ],
                                        )
                                      ]),
                                ),
                                Visibility(
                                  visible: status == "new" ? true : false,
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: Checkbox(
                                      value: status == "new"
                                          ? value.shopsNew[index].isActive
                                          : false,
                                      onChanged: (val) {
                                        if (val) {
                                          if (status == "new") {
                                            if (!value
                                                .shopsNew[index].isActive) {
                                              final s = mProvider
                                                  .getShopDetail(value.shopsNew[index], status, 1)
                                                  .doOnListen(() {})
                                                  .doOnDone(() {})
                                                  .listen((data) {
                                                //success
                                                ShopDetailResponse response = ShopDetailResponse.fromJson(data);
                                                List<Status> list = List();
                                                if(response.result) {
                                                  response.data.orders.forEach((e) {
                                                    list.add(Status(e.trackingNumber, "picking", "picking"));
                                                  });
                                                }
                                                final h = mProvider.turnOnShop(list).listen((r){
                                                  LoginResponse res = LoginResponse.fromJson(r);
                                                  if(res.result) {
                                                    setState(() {
                                                      value.shopsNew[index].isActive = true;
                                                    });
                                                  }
                                                });
                                                mProvider.addSubscription(h);
                                              }, onError: (e) {
                                                //error
                                                dispatchFailure(context, e);
                                              });
                                              mProvider.addSubscription(s);
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
          buildProgress()
        ]),
      ),
    );
  }

  Consumer<PickupProvider> buildProgress() {
    return Consumer<PickupProvider>(builder: (context, value, child) {
      return Visibility(
        child: const CircularProgressIndicator(),
        visible: value.loading,
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
