import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/data/model/shop_detail_response.dart';
import 'package:driver_app/data/model/shop_response.dart';
import 'package:driver_app/data/model/status.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home_provider.dart';

class WaitPage extends PageProvideNode<HomeProvider> {
  final BuildContext homeContext;
  final int type;
  WaitPage(this.homeContext, this.type);

  @override
  Widget buildContent(BuildContext context) {
    return _WaitContentPage(homeContext, mProvider, type);
  }
}

class _WaitContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final HomeProvider provider;
  final int type;
  _WaitContentPage(this.homeContext, this.provider, this.type);

  @override
  State<StatefulWidget> createState() {
    return _WaitContentState(homeContext);
  }
}

class _WaitContentState extends State<_WaitContentPage>
    with
        TickerProviderStateMixin<_WaitContentPage>,
        AutomaticKeepAliveClientMixin {
  final BuildContext homeContext;
  _WaitContentState(this.homeContext);

  HomeProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    Future.microtask(() => _loadData("wait", widget.type));
  }

  @override
  void dispose() {
    if (widget.type == 1) {
      mProvider.shopsWait.clear();
      mProvider.totalWait = 0;
      mProvider.pageWait = 0;
    } else {
      mProvider.shopsWaitReturn.clear();
      mProvider.totalWaitReturn = 0;
      mProvider.pageWaitReturn = 0;
    }
    super.dispose();
  }

  void _loadData(String status, int type) {
    final s = mProvider
        .getShops(status, type)
        .doOnListen(() {})
        .doOnDone(() {})
        .listen((data) {
      ShopResponse response = ShopResponse.fromJson(data);
      if (!response.result) {
        if (response.msg == "user not authorized") {
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
    super.build(context);
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return SizedBox.expand(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (widget.type == 1) {
              if (!mProvider.loadingWait &&
                  mProvider.pageWait * mProvider.limit < mProvider.totalWait &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadData("wait_picking", 1);
              }
            } else {
              if (!mProvider.loadingWaitReturn &&
                  mProvider.pageWaitReturn * mProvider.limit <
                      mProvider.totalWaitReturn &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadData("wait_return", 2);
              }
            }
          },
          child:
          Stack(alignment: AlignmentDirectional.center, children: <Widget>[
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Container(
                color: primaryColorHome,
                child: ListView.builder(
                  itemCount: widget.type == 1
                      ? (value.shopsWait == null ? 0 : value.shopsWait.length)
                      : (value.shopsWaitReturn == null
                      ? 0
                      : value.shopsWaitReturn.length),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      child: Card(
                        margin: EdgeInsets.all(0.5),
                        color: secondColorHome,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
                          child: InkWell(
                            onTap: () async {
                              switch (widget.type) {
                                case 1:
                                  if (value.shopsWait[index].isActive) {
                                    final res = await Navigator.push(
                                        homeContext,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                value.shopsWait[index],
                                                "wait_picking",
                                                1)));
                                    if (res == null) {
                                      mProvider.shopsNew.clear();
                                      mProvider.totalNew = 0;
                                      mProvider.pageNew = 0;
                                      _loadData("new", 1);
                                      mProvider.shopsWait.clear();
                                      mProvider.totalWait = 0;
                                      mProvider.pageWait = 0;
                                      _loadData("wait_picking", 1);
                                      mProvider.shopsSuccess.clear();
                                      mProvider.totalSuccess = 0;
                                      mProvider.pageSuccess = 0;
                                      _loadData("picked", 1);
                                      mProvider.shopsCancel.clear();
                                      mProvider.totalCancel = 0;
                                      mProvider.pageCancel = 0;
                                      _loadData("fail", 1);
                                    } else {
                                      mProvider.shopsNew.clear();
                                      mProvider.totalNew = 0;
                                      mProvider.pageNew = 0;
                                      _loadData("new", 1);
                                      mProvider.shopsWait.clear();
                                      mProvider.totalWait = 0;
                                      mProvider.pageWait = 0;
                                      _loadData("wait_picking", 1);
                                      mProvider.shopsSuccess.clear();
                                      mProvider.totalSuccess = 0;
                                      mProvider.pageSuccess = 0;
                                      _loadData("picked", 1);
                                      mProvider.shopsCancel.clear();
                                      mProvider.totalCancel = 0;
                                      mProvider.pageCancel = 0;
                                      _loadData("fail", 1);
                                    }
                                  }
                                  break;
                                case 2:
                                  if (value.shopsWaitReturn[index].isActive) {
                                    final res = await Navigator.push(
                                        homeContext,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                value.shopsWaitReturn[index],
                                                "wait_return",
                                                2)));
                                    if (res == null) {
                                      mProvider.shopsNewReturn.clear();
                                      mProvider.totalNewReturn = 0;
                                      mProvider.pageNewReturn = 0;
                                      _loadData("new", 2);
                                      mProvider.shopsWaitReturn.clear();
                                      mProvider.totalWaitReturn = 0;
                                      mProvider.pageWaitReturn = 0;
                                      _loadData("wait_return", 2);
                                      mProvider.shopsSuccessReturn.clear();
                                      mProvider.totalSuccessReturn = 0;
                                      mProvider.pageSuccessReturn = 0;
                                      _loadData("picked", 2);
                                      mProvider.shopsCancelReturn.clear();
                                      mProvider.totalCancelReturn = 0;
                                      mProvider.pageCancelReturn = 0;
                                      _loadData("fail", 2);
                                    } else {
                                      mProvider.shopsNewReturn.clear();
                                      mProvider.totalNewReturn = 0;
                                      mProvider.pageNewReturn = 0;
                                      _loadData("new", 2);
                                      mProvider.shopsWaitReturn.clear();
                                      mProvider.totalWaitReturn = 0;
                                      mProvider.pageWaitReturn = 0;
                                      _loadData("wait_return", 2);
                                      mProvider.shopsSuccessReturn.clear();
                                      mProvider.totalSuccessReturn = 0;
                                      mProvider.pageSuccessReturn = 0;
                                      _loadData("picked", 2);
                                      mProvider.shopsCancelReturn.clear();
                                      mProvider.totalCancelReturn = 0;
                                      mProvider.pageCancelReturn = 0;
                                      _loadData("fail", 2);
                                    }
                                  }
                                  break;
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(right: 8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent,
                                  ),
                                  child: Text((index + 1).toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                          16.0)), // You can add a Icon instead of text also, like below.
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            widget.type == 1
                                                ? value.shopsWait[index]
                                                .fromName +
                                                " (" +
                                                value.shopsWait[index]
                                                    .totalOrders +
                                                ")"
                                                : value.shopsWaitReturn[index]
                                                .fromName +
                                                " (" +
                                                value.shopsWaitReturn[index]
                                                    .totalOrders +
                                                ")",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          SizedBox(height: 8),
                                          Row(children: <Widget>[
                                            Icon(Icons.location_on,
                                                size: 18,
                                                color: Colors.white60),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                widget.type == 1
                                                    ? value.shopsWait[index]
                                                    .fromAddress
                                                    : value
                                                    .shopsWaitReturn[index]
                                                    .fromAddress,
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
                                                    (widget.type == 1
                                                        ? value.shopsWait[index]
                                                        ?.fromPhone
                                                        : value
                                                        .shopsWaitReturn[
                                                    index]
                                                        ?.fromPhone)),
                                                child: Text(
                                                  widget.type == 1
                                                      ? value.shopsWait[index]
                                                      .fromPhone
                                                      : value
                                                      .shopsWaitReturn[index]
                                                      .fromPhone,
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
                                                widget.type == 1
                                                    ? value.shopsWait[index]
                                                    .totalOrders
                                                    .toString() +
                                                    " đơn hàng - nặng " +
                                                    value.shopsWait[index]
                                                        .totalWeight +
                                                    "g"
                                                    : value
                                                    .shopsWaitReturn[
                                                index]
                                                    .totalOrders
                                                    .toString() +
                                                    " đơn hàng - nặng " +
                                                    value
                                                        .shopsWaitReturn[
                                                    index]
                                                        .totalWeight +
                                                    "g",
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
                                                widget.type == 1
                                                    ? value.shopsWait[index]
                                                    .fullCount
                                                    : value
                                                    .shopsWaitReturn[index]
                                                    .fullCount,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white60),
                                              )
                                            ],
                                          )
                                        ]),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Transform.scale(
                                      scale: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (this.mounted) {
                                            if (widget.type == 1) {
                                              if (!value
                                                  .shopsWait[index].isActive) {
                                                final s = mProvider
                                                    .getShopDetail(
                                                    value.shopsWait[index],
                                                    "wait_picking",
                                                    1)
                                                    .doOnListen(() {})
                                                    .doOnDone(() {})
                                                    .listen((data) {
                                                  //success
                                                  ShopDetailResponse response =
                                                  ShopDetailResponse
                                                      .fromJson(data);
                                                  List<Status> list = List();
                                                  if (response.result) {
                                                    response.data.orders
                                                        .forEach((e) {
                                                      list.add(Status(
                                                          e.trackingNumber,
                                                          "picking",
                                                          "picking"));
                                                    });
                                                  }
                                                  final h = mProvider
                                                      .turnOnShop(list, 1)
                                                      .listen((r) {
                                                    LoginResponse res =
                                                    LoginResponse.fromJson(
                                                        r);
                                                    if (res.result) {
                                                      setState(() {
                                                        value.shopsWait[index]
                                                            .isActive = true;
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
                                            } else {
                                              if (!value.shopsWaitReturn[index]
                                                  .isActive) {
                                                final s = mProvider
                                                    .getShopDetail(
                                                    value.shopsWaitReturn[
                                                    index],
                                                    "wait_return",
                                                    2)
                                                    .doOnListen(() {})
                                                    .doOnDone(() {})
                                                    .listen((data) {
                                                  //success
                                                  ShopDetailResponse response =
                                                  ShopDetailResponse
                                                      .fromJson(data);
                                                  List<Status> list = List();
                                                  if (response.result) {
                                                    response.data.orders
                                                        .forEach((e) {
                                                      list.add(Status(
                                                          e.trackingNumber,
                                                          "picking",
                                                          "picking"));
                                                    });
                                                  }
                                                  final h = mProvider
                                                      .turnOnShop(list, 2)
                                                      .listen((r) {
                                                    LoginResponse res =
                                                    LoginResponse.fromJson(
                                                        r);
                                                    if (res.result) {
                                                      setState(() {
                                                        value
                                                            .shopsWaitReturn[
                                                        index]
                                                            .isActive = true;
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
                                        child: Switch(
                                          inactiveThumbColor: (widget.type == 1
                                              ? value
                                              .shopsWait[index].isActive
                                              : value.shopsWaitReturn[index]
                                              .isActive)
                                              ? Colors.blueAccent
                                              : Colors.grey.shade400,
                                          inactiveTrackColor: (widget.type == 1
                                              ? value
                                              .shopsWait[index].isActive
                                              : value.shopsWaitReturn[index]
                                              .isActive)
                                              ? Colors.blueAccent
                                              .withAlpha(0x80)
                                              : Colors.white30,
                                          value: widget.type == 1
                                              ? value.shopsWait[index].isActive
                                              : value.shopsWaitReturn[index]
                                              .isActive,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.type == 1
                                          ? value.shopsWait[index].isActive
                                          : value
                                          .shopsWaitReturn[index].isActive,
                                      child: Container(
                                          margin:
                                          const EdgeInsets.only(top: 60),
                                          child: Icon(
                                            Icons.navigate_next,
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
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
            ),
            Visibility(
              child: const CircularProgressIndicator(),
              visible:
              widget.type == 1 ? value.loadingWait : value.loadingWaitReturn,
            )
          ]),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
