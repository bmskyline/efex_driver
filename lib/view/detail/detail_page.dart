import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_provider.dart';
import 'package:driver_app/view/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          title: Image.asset('assets/logo_hor.png', fit: BoxFit.cover),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Image.asset("assets/barcode.png"),
              onPressed: () {
                Toast.show("Scan barcode");
              },
            ),
          ],
        ),
        body: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          SizedBox.expand(
            child: Consumer<DetailProvider>(builder: (context, value, child) {
              return Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            value.response?.orders == null
                                ? ""
                                : value.response?.orders[0].fromName,
                            style: TextStyle(fontSize: 22,color: Colors.white)),
                        Text(
                            value.response?.orders == null
                                ? ""
                                : value.response?.orders[0].fromPhone,
                            style: TextStyle(fontSize: 18,color: Colors.blueAccent)),
                        Text(
                            value.response?.orders == null
                                ? ""
                                : value.response.orders[0].fromAddress,
                            style: TextStyle(fontSize: 18,color: Colors.white60)),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                        itemCount: value.response?.orders == null
                            ? 0
                            : value.response.orders.length,
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderDetailPage(
                                              value.response.orders[index])),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        value.response.orders[index]
                                            .trackingNumber,
                                        style: TextStyle(fontSize: 20,color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "Tong san pham: " +
                                            value.response.orders[index]
                                                .products.length
                                                .toString(),
                                        style: TextStyle(fontSize: 18,color: Colors.white60),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        "Tong trong luong: " +
                                            value.response.orders[index]
                                                .weightOfProduct()
                                                .toString() +
                                            "g",
                                        style: TextStyle(fontSize: 18,color: Colors.white60),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        "Ghi chu: " +
                                            value.response.orders[index]
                                                .note,
                                        style: TextStyle(fontSize: 18,color: Colors.white60),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
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
