import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_provider.dart';
import 'package:driver_app/view/order_detail/order_detail.dart';
import 'package:driver_app/view/order_list/order_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends PageProvideNode<DetailProvider> {
  final Shop _shop;
  final String status;
  final int type;
  DetailPage(this._shop, this.status, this.type);

  @override
  Widget buildContent(BuildContext context) {
    return _DetailContentPage(mProvider, _shop, status, type);
  }
}

class _DetailContentPage extends StatefulWidget {
  final DetailProvider provider;
  final Shop _shop;
  final String status;
  final int type;

  _DetailContentPage(this.provider, this._shop, this.status, this.type);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<_DetailContentPage>
    with TickerProviderStateMixin<_DetailContentPage> {
  DetailProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    _loadData(widget._shop, widget.status, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorHome,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColorHome,
          title: Image.asset('assets/logo_hor.png',
              fit: BoxFit.fitHeight, height: 32),
          actions: <Widget>[
            // action button
            Visibility(
              visible: (widget.status == "fail" || widget.status == "picked")
                  ? false
                  : true,
              child: IconButton(
                icon: Image.asset("assets/barcode.png"),
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderListPage(
                              mProvider.orders, List(), widget.type)));
                  if (result != null) {
                    if ((result as List)[0] == true) {
                      mProvider.orders?.removeWhere((e) =>
                          (result as List)[1]?.contains(e.trackingNumber));
                      if (mProvider.orders.isEmpty) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
        body: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          SizedBox.expand(
            child: Consumer<DetailProvider>(builder: (context, value, child) {
              return Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            value.orders == null
                                ? ""
                                : (value.orders?.isEmpty == true
                                    ? ""
                                    : value.orders
                                            .elementAt(0)
                                            .fromName +
                                        " (" +
                                        value.orders?.length
                                            .toString() +
                                        ")"),
                            style: TextStyle(fontSize: 22, color: Colors.white),
                            textAlign: TextAlign.left),
                        InkWell(
                          onTap: () => launch("tel://" +
                              (value.orders == null
                                  ? ""
                                  : (value?.orders?.isEmpty == true
                                      ? ""
                                      : value?.orders
                                          ?.elementAt(0)
                                          ?.fromPhone))),
                          child: Text(
                              value.orders == null
                                  ? ""
                                  : (value?.orders?.isEmpty == true
                                      ? ""
                                      : value?.orders
                                          ?.elementAt(0)
                                          ?.fromPhone),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.left),
                        ),
                        Text(
                            value.orders == null
                                ? ""
                                : (value?.orders?.isEmpty == true
                                    ? ""
                                    : value?.orders
                                        ?.elementAt(0)
                                        ?.fromAddress),
                            style:
                                TextStyle(fontSize: 20, color: Colors.white60),
                            textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                  Flexible(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!mProvider.loading &&
                            mProvider.page * mProvider.limit < mProvider.total &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          _loadData(widget._shop, widget.status, widget.type);
                      }
                  },
                      child: ListView.builder(
                          itemCount: value.orders == null
                              ? 0
                              : (value?.orders?.isEmpty == true
                                  ? 0
                                  : value.orders.length),
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              child: Card(
                                margin: EdgeInsets.all(0.5),
                                color: secondColorHome,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OrderDetailPage(
                                                value.orders[index],
                                                widget.status,
                                                widget.type)),
                                      );
                                      if (result != null) {
                                        //huy = fail, wait = updatestatus, xac nhan = picked
                                        switch ((result as List)[0]) {
                                          case "fail":
                                          case "picked":
                                          case "picking1":
                                          case "returning1":
                                            value.orders?.removeWhere(
                                                (e) =>
                                                    e.trackingNumber ==
                                                    (result as List)[1]);
                                            if (value.orders.isEmpty) {
                                              Navigator.pop(context);
                                            }
                                            break;
                                          default:
                                            value.orders?.forEach((e) {
                                              if (e.trackingNumber ==
                                                  (result as List)[1]) {
                                                e.currentStatus =
                                                    (result as List)[0];
                                              }
                                            });
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                value.orders[index]
                                                    .trackingNumber,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: 'Tổng sản phẩm: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white60),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: value

                                                            .orders[index]
                                                            .products
                                                            .length
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: 'Tổng trọng lượng: ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white60),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: value
                                                                .orders[index]
                                                                .weightOfProduct()
                                                                .toString() +
                                                            'g',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  "Ghi chú: " +
                                                      (value.orders[index]
                                                          .note ?? ""),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white60),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  "Tài xế: " +
                                                      (value.orders[index]
                                                          .reason ?? ""),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white60),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  "Thời gian: " +
                                                      (value.orders[index]
                                                          .updatedTime != null ? DateFormat('dd-MM-yyyy HH:mm:ss').format(value.orders[index]
                                                          .updatedTime) : ""),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white60),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              );
            }),
          ),
          buildProgress()
        ]));
  }

  Consumer<DetailProvider> buildProgress() {
    return Consumer<DetailProvider>(builder: (context, value, child) {
      return Visibility(
        child: const CircularProgressIndicator(),
        visible: value.loading,
      );
    });
  }

  void _loadData(Shop shop, String status, int type) {
    final s = mProvider
        .getShopDetail(shop, status, type)
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
}
