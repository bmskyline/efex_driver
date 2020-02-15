import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:driver_app/view/scan/scan_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:vibration/vibration.dart';

class ScanPage extends PageProvideNode<ScanProvider> {
  final List<Order> orders;
  ScanPage(this.orders, List<String> result) {
    mProvider.addList(result);
  }

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
        backgroundColor: primaryColorHome,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColorHome,
          title: Image.asset('assets/logo_hor.png', fit: BoxFit.fitHeight, height: 32),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 200.0,
              child: QrCamera(
                qrCodeCallback: (code) async {
                  bool hasInList = false;
                  if (!mProvider.getListScan().contains(code)) {
                    mProvider.getListScan().add(code);
                    for (Order o in widget.orders) {
                      if (o.trackingNumber == code) {
                        mProvider.list = o.trackingNumber;
                        hasInList = true;
                        break;
                      }
                    }
                    if (!hasInList) {
                      if (await Vibration.hasVibrator()) {
                        Vibration.vibrate();
                      }
                      Toast.show("Đơn hàng " + code + " không tồn tại ");
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: Consumer<ScanProvider>(builder: (context, value, child) {
                return Container(
                  margin: EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: value.getList().length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        (index + 1).toString() +
                            '. ' +
                            value.getList().elementAt(index),
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      );
                    },
                  ),
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
                        Navigator.pop(context, value.getList().toList());
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
