import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:driver_app/view/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessPage extends PageProvideNode<HomeProvider> {
  final BuildContext homeContext;
  final int type;
  SuccessPage(this.homeContext, this.type);

  @override
  Widget buildContent(BuildContext context) {
    return _SuccessContentPage(homeContext, mProvider, type);
  }
}

class _SuccessContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final HomeProvider provider;
  final int type;

  _SuccessContentPage(this.homeContext, this.provider, this.type);

  @override
  State<StatefulWidget> createState() {
    return _SuccessContentState(homeContext);
  }
}

class _SuccessContentState extends State<_SuccessContentPage>
    with
        TickerProviderStateMixin<_SuccessContentPage>,
        AutomaticKeepAliveClientMixin {
  final BuildContext homeContext;
  _SuccessContentState(this.homeContext);

  HomeProvider mProvider;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    if (widget.type == 1) {
      mProvider.shopsSuccess.clear();
      mProvider.totalSuccess = 0;
      mProvider.pageSuccess = 0;
    } else {
      mProvider.shopsSuccessReturn.clear();
      mProvider.totalSuccessReturn = 0;
      mProvider.pageSuccessReturn = 0;
    }
    _loadData();
  }

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    Future.microtask(() => _loadData());
  }

  @override
  void dispose() {
    if (widget.type == 1) {
      mProvider.shopsSuccess = List();
      mProvider.totalSuccess = 0;
      mProvider.pageSuccess = 0;
    } else {
      mProvider.shopsSuccessReturn = List();
      mProvider.totalSuccessReturn = 0;
      mProvider.pageSuccessReturn = 0;
    }
    super.dispose();
  }

  void _loadData() {
    final s = mProvider
        .getShops("picked", widget.type, _refreshController.isRefresh)
        .doOnListen(() {})
        .doOnDone(() {
      if (_refreshController.isRefresh) _refreshController.refreshCompleted();
    }).listen((data) {
      //success
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
              if (!mProvider.loadingSuccess &&
                  mProvider.pageSuccess * mProvider.limit <
                      mProvider.totalSuccess &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadData();
              }
            } else {
              if (!mProvider.loadingSuccessReturn &&
                  mProvider.pageSuccessReturn * mProvider.limit <
                      mProvider.totalSuccessReturn &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadData();
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
                        ? (value.shopsSuccess == null
                            ? 0
                            : value.shopsSuccess.length)
                        : (value.shopsSuccessReturn == null
                            ? 0
                            : value.shopsSuccessReturn.length),
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        child: Card(
                          margin: EdgeInsets.all(0.5),
                          color: secondColorHome,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                            child: InkWell(
                              onTap: () async {
                                switch (widget.type) {
                                  case 1:
                                    Navigator.push(
                                        homeContext,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                value.shopsSuccess[index].shopId,
                                                "picked",
                                                1)));
                                    break;
                                  case 2:
                                    Navigator.push(
                                        homeContext,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                value.shopsSuccessReturn[index].shopId,
                                                "picked",
                                                2)));
                                    break;
                                }
                              },
                              child: listItem(index, value),
                            ),
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
              visible: widget.type == 1
                  ? value.loadingSuccess
                  : value.loadingSuccessReturn,
            )
          ]),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;

  Widget listItem(int index, HomeProvider value) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            child: Container(
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.type == 1
                          ? value.shopsSuccess[index].name +
                              " (" +
                              value.shopsSuccess[index].totalOrders +
                              ")"
                          : value.shopsSuccessReturn[index].name +
                              " (" +
                              value.shopsSuccessReturn[index].totalOrders +
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
                              ? value.shopsSuccess[index].address
                              : value.shopsSuccessReturn[index].address,
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
                                  ? value.shopsSuccess[index]?.phone
                                  : value
                                      .shopsSuccessReturn[index]?.phone)),
                          child: Text(
                            widget.type == 1
                                ? value.shopsSuccess[index].phone
                                : value.shopsSuccessReturn[index].phone,
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
                              ? value.shopsSuccess[index].totalOrders
                                      .toString() +
                                  " đơn hàng - nặng " +
                                  value.shopsSuccess[index].totalWeight +
                                  "g"
                              : value.shopsSuccessReturn[index].totalOrders
                                      .toString() +
                                  " đơn hàng - nặng " +
                                  value.shopsSuccessReturn[index].totalWeight +
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
                              ? value.shopsSuccess[index].fullCount
                              : value.shopsSuccessReturn[index].fullCount,
                          style: TextStyle(fontSize: 16, color: Colors.white60),
                        )
                      ],
                    )
                  ]),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 8),
              child: Icon(Icons.navigate_next, color: Colors.white))
        ],
      ),
    );
  }
}
