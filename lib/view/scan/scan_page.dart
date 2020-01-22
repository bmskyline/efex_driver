import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/order_list/order_list.dart';
import 'package:driver_app/view/scan/scan_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ScanPage extends PageProvideNode<ScanProvider> {
  final List<Order> orders;
  ScanPage(this.orders);

  @override
  Widget buildContent(BuildContext context) {
    return _ScanContentPage(mProvider, orders);
  }
}

class _ScanContentPage extends StatefulWidget {
  final ScanProvider provider;
  final List<Order> orders;

  _ScanContentPage(this.provider, this.orders);

  @override
  State<StatefulWidget> createState() {
    return _ScanPageState();
  }
}

class _ScanPageState extends State<_ScanContentPage>
    with TickerProviderStateMixin<_ScanContentPage> {
  ScanProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorHome,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColorHome,
          title: Image.asset('assets/logo_hor.png', fit: BoxFit.cover),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 200.0,
              child: QrCamera(
                qrCodeCallback: (code) {
                  for (Order o in widget.orders) {
                    if (o.trackingNumber == code) {
                      mProvider.list = o;
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: Consumer<ScanProvider>(builder: (context, value, child) {
                return ListView.builder(
                  itemCount: value.getList().length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                      value.getList().elementAt(index).trackingNumber,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    );
                  },
                );
              }),
            ),
            Consumer<ScanProvider>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.getList().isEmpty ? false : true,
                  child: Container(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrderListPage(value.getList().toList())));
                      },
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(0),
                      child: Text(
                        "Xong",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ));
  }
}
