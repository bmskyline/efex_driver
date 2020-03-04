import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:driver_app/view/order_detail/order_detail.dart';
import 'package:driver_app/view/order_list/order_list_provider.dart';
import 'package:driver_app/view/scan/list_page.dart';
import 'package:driver_app/view/scan/scan_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OrderListPage extends PageProvideNode<OrderListProvider> {
  final List<Order> orders;
  final List<String> result;
  final int type;
  OrderListPage(this.orders, this.result, this.type);

  @override
  Widget buildContent(BuildContext context) {
    return _OrderListContentPage(mProvider, orders, result, type);
  }
}

class _OrderListContentPage extends StatefulWidget {
  final OrderListProvider provider;
  final List<Order> orders;
  final List<String> result;
  final int type;
  _OrderListContentPage(this.provider, this.orders, this.result, this.type);

  @override
  State<StatefulWidget> createState() {
    return _OrderListState(result);
  }
}

class _OrderListState extends State<_OrderListContentPage>
    with TickerProviderStateMixin<_OrderListContentPage> {
  OrderListProvider mProvider;
  List<String> result;
  _OrderListState(this.result);

  Future getImage() async {
    FocusScope.of(context).unfocus(focusPrevious: true);
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    mProvider.image = image;
  }

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondColorHome,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColorHome,
          title: Image.asset('assets/logo_hor.png',
              fit: BoxFit.fitHeight, height: 32),
        ),
        body: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ScanPage(widget.orders, result)));
                          if (res != null) {
                            this.result = (res as List<String>);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,width: 1
                            )
                          , color: primaryColorHome),
                          height: 64,
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Image.asset("assets/barcode.png"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListPage(widget.orders, result)));
                          if (res != null) {
                            this.result = (res as List<String>);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,width: 1
                              )
                              , color: primaryColorHome),
                          height: 64,
                          width: double.infinity,
                          child: Icon(Icons.playlist_add, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result == null ? 0 : result.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(
                                      getOrder(widget.orders, result[index]),
                                      "picked",
                                      widget.type)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    (index + 1).toString() +
                                        '. ' +
                                        result[index],
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
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
                      );
                    }),
                Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: TextField(
                      maxLength: 100,
                      style: TextStyle(color: Colors.black),
                      maxLines: 3,
                      onChanged: (val) => mProvider.reason = val,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                          hintText: "Ghi chú!", fillColor: Colors.white),
                    )),
                Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: Consumer<OrderListProvider>(
                        builder: (context, value, child) {
                          return value.image == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 30.0,
                                    ),
                                    Text("Hình ảnh")
                                  ],
                                )
                              : Image.file(value.image);
                        },
                      ),
                    )),
                Container(
                  width: double.infinity,
                  child: Consumer<OrderListProvider>(
                      builder: (context, value, child) {
                    return Visibility(
                      visible: (value.image != null && result.isNotEmpty)
                          ? true
                          : false,
                      child: CupertinoButton(
                        onPressed: () {
                          mProvider
                              .updateOrders(result, value.reason, widget.type, widget.orders[0].fromName)
                              .listen((r) {
                            LoginResponse res = LoginResponse.fromJson(r);
                            if (res.result) {
                              Toast.show("Xác nhận thành công!");
                              Navigator.pop(context, [true, result]);
                            } else
                              Toast.show("Vui lòng thử lại!");
                          });
                        },
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(0),
                        child: Text(
                          "Xác nhận",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
          buildProgress()
        ]));
  }

  Consumer<OrderListProvider> buildProgress() {
    return Consumer<OrderListProvider>(builder: (context, value, child) {
      return Visibility(
        child: const CircularProgressIndicator(),
        visible: value.loading,
      );
    });
  }

  Order getOrder(List<Order> orders, String result) {
    for (var o in orders) {
      if (o.trackingNumber == result) {
        return o;
      }
    }
    return null;
  }
}
