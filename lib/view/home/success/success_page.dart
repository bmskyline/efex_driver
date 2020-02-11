import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:driver_app/view/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessPage extends PageProvideNode<HomeProvider> {
  final BuildContext homeContext;
  final int status;
  SuccessPage(this.homeContext, this.status);

  @override
  Widget buildContent(BuildContext context) {
    return _SuccessContentPage(homeContext, mProvider, status);
  }
}

class _SuccessContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final HomeProvider provider;
  final int status;

  _SuccessContentPage(this.homeContext, this.provider, this.status);

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

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    Future.microtask(() => _loadData());
  }

  @override
  void dispose() {
    if (widget.status == 1) {
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
        .getShops("picked", widget.status)
        .doOnListen(() {})
        .doOnDone(() {})
        .listen((data) {
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
            if (widget.status == 1) {
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
                child: ListView.builder(
                  itemCount: widget.status == 1
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
                              switch (widget.status) {
                                case 1:
                                  Navigator.push(
                                      homeContext,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              value.shopsSuccess[index],
                                              "picked",
                                              1)));
                                  break;
                                case 2:
                                  Navigator.push(
                                      homeContext,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              value.shopsSuccessReturn[index],
                                              "picked",
                                              2)));
                                  break;
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(right: 8.0),
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent,
                                  ),
                                  child: new Text((index + 1).toString(),
                                      style: new TextStyle(
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
                                            widget.status == 1
                                                ? value.shopsSuccess[index]
                                                        .fromName +
                                                    " (" +
                                                    value.shopsSuccess[index]
                                                        .totalOrders +
                                                    ")"
                                                : value
                                                        .shopsSuccessReturn[
                                                            index]
                                                        .fromName +
                                                    " (" +
                                                    value
                                                        .shopsSuccessReturn[
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
                                                widget.status == 1
                                                    ? value.shopsSuccess[index]
                                                        .fromAddress
                                                    : value
                                                        .shopsSuccessReturn[
                                                            index]
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
                                                    (widget.status == 1
                                                        ? value
                                                            .shopsSuccess[index]
                                                            ?.fromPhone
                                                        : value
                                                            .shopsSuccessReturn[
                                                                index]
                                                            ?.fromPhone)),
                                                child: Text(
                                                  widget.status == 1
                                                      ? value
                                                          .shopsSuccess[index]
                                                          .fromPhone
                                                      : value
                                                          .shopsSuccessReturn[
                                                              index]
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
                                                widget.status == 1
                                                    ? value.shopsSuccess[index]
                                                            .totalOrders
                                                            .toString() +
                                                        " đơn hàng - nặng " +
                                                        value
                                                            .shopsSuccess[index]
                                                            .totalWeight +
                                                        "g"
                                                    : value
                                                            .shopsSuccessReturn[
                                                                index]
                                                            .totalOrders
                                                            .toString() +
                                                        " đơn hàng - nặng " +
                                                        value
                                                            .shopsSuccessReturn[
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
                                                widget.status == 1
                                                    ? value.shopsSuccess[index]
                                                        .fullCount
                                                    : value
                                                        .shopsSuccessReturn[
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
              visible: widget.status == 1
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
}
