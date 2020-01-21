import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:driver_app/view/home/return/return_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReturnPage extends PageProvideNode<ReturnProvider> {
  final BuildContext homeContext;
  final String status;
  ReturnPage(this.homeContext, this.status);

  @override
  Widget buildContent(BuildContext context) {
    return _ReturnContentPage(homeContext, mProvider, status);
  }
}

class _ReturnContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final ReturnProvider provider;
  final String status;
  _ReturnContentPage(this.homeContext, this.provider, this.status);

  @override
  State<StatefulWidget> createState() {
    return _ReturnContentState(homeContext, status);
  }
}

class _ReturnContentState extends State<_ReturnContentPage>
    with
        TickerProviderStateMixin<_ReturnContentPage>,
        AutomaticKeepAliveClientMixin<_ReturnContentPage> {
  BuildContext homeContext;
  String status;
  bool switchValue = false;

  _ReturnContentState(this.homeContext, this.status);

  ReturnProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    _loadData();
  }

  void _loadData() {
    final s = mProvider
        .getShops(widget.status)
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
          Consumer<ReturnProvider>(builder: (context, value, child) {
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
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                homeContext,
                                MaterialPageRoute(
                                    builder: (context) => status == "new"
                                        ? DetailPage(
                                            value.shopsNew[index], status, 1)
                                        : (status == "picked"
                                            ? DetailPage(
                                                value.shopsSuccess[index],
                                                status,
                                                1)
                                            : DetailPage(
                                                value.shopsCancel[index],
                                                status,
                                                1))),
                              );
                            },
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
                                                      .fullCount +
                                                  ")"
                                              : (status == "picked"
                                                  ? value.shopsSuccess[index]
                                                      .fromName
                                                  : value.shopsCancel[index]
                                                      .fromName),
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
                                Switch(
                                  activeColor: Colors.white,
                                  value: switchValue,
                                  onChanged: (value) {
                                    setState(() {
                                      switchValue = value;
                                    });
                                  },
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

  Consumer<ReturnProvider> buildProgress() {
    return Consumer<ReturnProvider>(builder: (context, value, child) {
      return Visibility(
        child: const CircularProgressIndicator(),
        visible: value.loading,
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}