import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_detail_response.dart';
import 'package:driver_app/data/model/shop_response.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:driver_app/view/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class NewPage extends PageProvideNode<HomeProvider> {
  final BuildContext homeContext;
  final int type;
  NewPage(this.homeContext, this.type);

  @override
  Widget buildContent(BuildContext context) {
    return _NewContentPage(homeContext, mProvider, type);
  }
}

class _NewContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final HomeProvider provider;
  final int type;
  _NewContentPage(this.homeContext, this.provider, this.type);

  @override
  State<StatefulWidget> createState() {
    return _NewContentState(homeContext);
  }
}

class _NewContentState extends State<_NewContentPage>
    with
        TickerProviderStateMixin<_NewContentPage>,
        AutomaticKeepAliveClientMixin {
  final BuildContext homeContext;
  _NewContentState(this.homeContext);

  HomeProvider mProvider;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    if (widget.type == 1) {
      mProvider.shopsNew.clear();
      mProvider.totalNew = 0;
      mProvider.pageNew = 0;
    } else {
      mProvider.shopsNewReturn.clear();
      mProvider.totalNewReturn = 0;
      mProvider.pageNewReturn = 0;
    }
    _loadData("new", widget.type);
  }

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    Future.microtask(() => _loadData("new", widget.type));
  }

  @override
  void dispose() {
    if (widget.type == 1) {
      mProvider.shopsNew.clear();
      mProvider.totalNew = 0;
      mProvider.pageNew = 0;
    } else {
      mProvider.shopsNewReturn.clear();
      mProvider.totalNewReturn = 0;
      mProvider.pageNewReturn = 0;
    }
    super.dispose();
  }

  void _loadData(String status, int type) {
    final s = mProvider
        .getShops(status, type, _refreshController.isRefresh)
        .doOnListen(() {})
        .doOnDone(() {
      if (_refreshController.isRefresh) _refreshController.refreshCompleted();
    }).listen((data) {
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
              if (!mProvider.loadingNew &&
                  mProvider.pageNew * mProvider.limit < mProvider.totalNew &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadData("new", 1);
              }
            } else {
              if (!mProvider.loadingNewReturn &&
                  mProvider.pageNewReturn * mProvider.limit <
                      mProvider.totalNewReturn &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadData("new", 2);
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
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: _refreshController,
                  onRefresh: _onLoading,
                  child: ListView.builder(
                    itemCount: widget.type == 1
                        ? (value.shopsNew == null ? 0 : value.shopsNew.length)
                        : (value.shopsNewReturn == null
                            ? 0
                            : value.shopsNewReturn.length),
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        child: Card(
                          margin: EdgeInsets.all(0.5),
                          color: secondColorHome,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
                            child: listItem(index, value),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              child: const CircularProgressIndicator(),
              visible:
                  widget.type == 1 ? value.loadingNew : value.loadingNewReturn,
            )
          ]),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;

  Widget listItem(int index, HomeProvider value) {
    return InkWell(
      onTap: () async {
        switch (widget.type) {
          case 1:
            if (value.shopsNew[index].isActive) {
              final res = await Navigator.push(
                  homeContext,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(value.shopsNew[index], "new", 1)));
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
            if (value.shopsNewReturn[index].isActive) {
              final res = await Navigator.push(
                  homeContext,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(value.shopsNewReturn[index], "new", 2)));
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.type == 1
                          ? value.shopsNew[index].fromName +
                              " (" +
                              value.shopsNew[index].totalOrders +
                              ")"
                          : value.shopsNewReturn[index].fromName +
                              " (" +
                              value.shopsNewReturn[index].totalOrders +
                              ")",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 8),
                    Row(children: <Widget>[
                      Icon(Icons.location_on, size: 18, color: Colors.white60),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.type == 1
                              ? value.shopsNew[index].fromAddress
                              : value.shopsNewReturn[index].fromAddress,
                          style: TextStyle(fontSize: 16, color: Colors.white60),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ]),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone, size: 18, color: Colors.white60),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () => launch("tel://" +
                              (widget.type == 1
                                  ? value.shopsNew[index]?.fromPhone
                                  : value.shopsNewReturn[index]?.fromPhone)),
                          child: Text(
                            widget.type == 1
                                ? value.shopsNew[index].fromPhone
                                : value.shopsNewReturn[index].fromPhone,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(Icons.border_color,
                            size: 18, color: Colors.white60),
                        SizedBox(width: 16),
                        Text(
                          widget.type == 1
                              ? value.shopsNew[index].totalOrders.toString() +
                                  " đơn hàng - nặng " +
                                  value.shopsNew[index].totalWeight +
                                  "g"
                              : value.shopsNewReturn[index].totalOrders
                                      .toString() +
                                  " đơn hàng - nặng " +
                                  value.shopsNewReturn[index].totalWeight +
                                  "g",
                          style: TextStyle(fontSize: 16, color: Colors.white60),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(Icons.access_time,
                            size: 18, color: Colors.white60),
                        SizedBox(width: 16),
                        Text(
                          widget.type == 1
                              ? value.shopsNew[index].fullCount
                              : value.shopsNewReturn[index].fullCount,
                          style: TextStyle(fontSize: 16, color: Colors.white60),
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
                  onTap: () async {
                    if (this.mounted) {
                      final result = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: widget.type == 1
                                    ? Text(
                                        "Đi tới shop ${value.shopsNew[index].fromName} lấy hàng")
                                    : Text(
                                        "Đi tới shop ${value.shopsNewReturn[index].fromName} trả hàng"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Hủy"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Xác nhận"),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  )
                                ],
                              ));
                      if (result != null && (result as bool)) {
                        if (widget.type == 1) {
                          if (!value.shopsNew[index].isActive) {
                            final s = mProvider
                                .getShopDetail(value.shopsNew[index], "new", 1)
                                .doOnListen(() {})
                                .doOnDone(() {})
                                .listen((data) {
                              //success
                              ShopDetailResponse response =
                                  ShopDetailResponse.fromJson(data);
                              if (response.result) {
                                value.shopsNew[index].isActive = true;
                              }
                            }, onError: (e) {
                              //error
                              dispatchFailure(context, e);
                            });
                            mProvider.addSubscription(s);
                          }
                        } else {
                          if (!value.shopsNewReturn[index].isActive) {
                            final s = mProvider
                                .getShopDetail(
                                    value.shopsNewReturn[index], "new", 2)
                                .doOnListen(() {})
                                .doOnDone(() {})
                                .listen((data) {
                              //success
                              ShopDetailResponse response =
                                  ShopDetailResponse.fromJson(data);
                              if (response.result) {
                                setState(() {
                                  value.shopsNewReturn[index].isActive = true;
                                });
                              }
                            }, onError: (e) {
                              //error
                              dispatchFailure(context, e);
                            });
                            mProvider.addSubscription(s);
                          }
                        }
                      }
                    }
                  },
                  child: Switch(
                    inactiveThumbColor: (widget.type == 1
                            ? value.shopsNew[index].isActive
                            : value.shopsNewReturn[index].isActive)
                        ? Colors.blueAccent
                        : Colors.grey.shade400,
                    inactiveTrackColor: (widget.type == 1
                            ? value.shopsNew[index].isActive
                            : value.shopsNewReturn[index].isActive)
                        ? Colors.blueAccent.withAlpha(0x80)
                        : Colors.white30,
                    value: widget.type == 1
                        ? value.shopsNew[index].isActive
                        : value.shopsNewReturn[index].isActive,
                  ),
                ),
              ),
              Visibility(
                visible: widget.type == 1
                    ? value.shopsNew[index].isActive
                    : value.shopsNewReturn[index].isActive,
                child: Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
