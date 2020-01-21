import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/scan/scan_provider.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ScanPage extends PageProvideNode<ScanProvider> {
  @override
  Widget buildContent(BuildContext context) {
    return _ScanContentPage(mProvider);
  }
}

class _ScanContentPage extends StatefulWidget {
  final ScanProvider provider;

  _ScanContentPage(this.provider);

  @override
  State<StatefulWidget> createState() {
    return _ScanPageState();
  }
}

class _ScanPageState extends State<_ScanContentPage>
    with TickerProviderStateMixin<_ScanContentPage> {
  ScanProvider mProvider;
  Set<String> list = Set();

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
            new SizedBox(
              height: 200.0,
              child: new QrCamera(
                qrCodeCallback: (code) {
                  setState(() {
                    list.add(code);
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(list.elementAt(index),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22
                  ),);
                },
              ),
            )
          ],
        )
    );
  }
}
