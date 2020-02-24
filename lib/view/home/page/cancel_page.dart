import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home_provider.dart';

class CancelPage extends PageProvideNode<HomeProvider> {
  final BuildContext homeContext;
  final int type;
  CancelPage(this.homeContext, this.type);

  @override
  Widget buildContent(BuildContext context) {
    return _CancelContentPage(homeContext, mProvider, type);
  }
}

class _CancelContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final HomeProvider provider;
  final int type;
  _CancelContentPage(this.homeContext, this.provider, this.type);

  @override
  State<StatefulWidget> createState() {
    return _CancelContentState(homeContext);
  }
}

class _CancelContentState extends State<_CancelContentPage>
    with
        TickerProviderStateMixin<_CancelContentPage>,
        AutomaticKeepAliveClientMixin {
  final BuildContext homeContext;
  _CancelContentState(this.homeContext);

  HomeProvider mProvider;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    if (widget.type == 1) {
      mProvider.shopsCancel.clear();
      mProvider.totalCancel = 0;
      mProvider.pageCancel = 0;
    } else {
      mProvider.shopsCancelReturn.clear();
      mProvider.totalCancelReturn = 0;
      mProvider.pageCancelReturn = 0;
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
      mProvider.shopsCancel.clear();
      mProvider.totalCancel = 0;
      mProvider.pageCancel = 0;
    } else {
      mProvider.shopsCancelReturn.clear();
      mProvider.totalCancelReturn = 0;
      mProvider.pageCancelReturn = 0;
    }
    super.dispose();
  }

  void _loadData() {
    final s = mProvider
        .getShops("fail", widget.type, _refreshController.isRefresh)
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
              if (!mProvider.loadingCancel &&
                  mProvider.pageCancel * mProvider.limit <
                      mProvider.totalCancel &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadData();
              }
            } else {
              if (!mProvider.loadingCancelReturn &&
                  mProvider.pageCancelReturn * mProvider.limit <
                      mProvider.totalCancelReturn &&
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
                        ? (value.shopsCancel == null
                            ? 0
                            : value.shopsCancel.length)
                        : (value.shopsCancelReturn == null
                            ? 0
                            : value.shopsCancelReturn.length),
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        child: Card(
                          margin: EdgeInsets.all(0.5),
                          color: secondColorHome,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                            child: InkWell(
                              onTap: () {
                                switch (widget.type) {
                                  case 1:
                                    //if (value.shopsCancel[index].isActive) {
                                    Navigator.push(
                                        homeContext,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                value.shopsCancel[index],
                                                "fail",
                                                1)));
                                    //}
                                    break;
                                  case 2:
                                    //if (value.shopsCancelReturn[index].isActive) {
                                    Navigator.push(
                                        homeContext,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                value.shopsCancelReturn[index],
                                                "fail",
                                                2)));
                                    // }
                                    break;
                                }
                              },
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        margin:
                                            const EdgeInsets.only(right: 8.0),
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
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                widget.type == 1
                                                    ? value.shopsCancel[index]
                                                            .fromName +
                                                        " (" +
                                                        value.shopsCancel[index]
                                                            .totalOrders +
                                                        ")"
                                                    : value
                                                            .shopsCancelReturn[
                                                                index]
                                                            .fromName +
                                                        " (" +
                                                        value
                                                            .shopsCancelReturn[
                                                                index]
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
                                                        ? value
                                                            .shopsCancel[index]
                                                            .fromAddress
                                                        : value
                                                            .shopsCancelReturn[
                                                                index]
                                                            .fromAddress,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white60),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                            ? value
                                                                .shopsCancel[
                                                                    index]
                                                                ?.fromPhone
                                                            : value
                                                                .shopsCancelReturn[
                                                                    index]
                                                                ?.fromPhone)),
                                                    child: Text(
                                                      widget.type == 1
                                                          ? value
                                                              .shopsCancel[
                                                                  index]
                                                              .fromPhone
                                                          : value
                                                              .shopsCancelReturn[
                                                                  index]
                                                              .fromPhone,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.blueAccent,
                                                          decoration:
                                                              TextDecoration
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
                                                        ? value
                                                                .shopsCancel[
                                                                    index]
                                                                .totalOrders
                                                                .toString() +
                                                            " đơn hàng - nặng " +
                                                            value
                                                                .shopsCancel[
                                                                    index]
                                                                .totalWeight +
                                                            "g"
                                                        : value
                                                                .shopsCancelReturn[
                                                                    index]
                                                                .totalOrders
                                                                .toString() +
                                                            " đơn hàng - nặng " +
                                                            value
                                                                .shopsCancelReturn[
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
                                                        ? value
                                                            .shopsCancel[index]
                                                            .fullCount
                                                        : value
                                                            .shopsCancelReturn[
                                                                index]
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
                                    Container(
                                        margin: EdgeInsets.only(left: 8),
                                        child: Icon(Icons.navigate_next,
                                            color: Colors.white))
                                  ],
                                ),
                              ),
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
                  ? value.loadingCancel
                  : value.loadingCancelReturn,
            )
          ]),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
