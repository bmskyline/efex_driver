import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_detail_provider.dart';

class WaitDialogPage extends PageProvideNode<OrderDetailProvider> {
  final String number;
  final String status;

  WaitDialogPage(this.number, this.status);

  @override
  Widget buildContent(BuildContext context) {
    return WaitDialogContent(mProvider, number, status);
  }
}

class WaitDialogContent extends StatefulWidget {
  final OrderDetailProvider provider;
  final String number;
  final String status;

  WaitDialogContent(this.provider, this.number, this.status);

  @override
  State<StatefulWidget> createState() => _WaitDialogContentState();
}

class _WaitDialogContentState extends State<WaitDialogContent> {
  OrderDetailProvider mProvider;
  String text;
  String updateStatus;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    switch(widget.status) {
      case "picking":
        text = "Lấy hàng lần 1 không thành công";
        updateStatus = "picking1";
        break;
      case "picking1":
        text = "Lấy hàng lần 2 không thành công";
        updateStatus = "picking2";
        break;
      case "picking2":
        text = "Lấy hàng lần 3 không thành công";
        updateStatus = "picking3";
        break;
      case "returning":
        text = "Trả hàng lần 1 không thành công";
        updateStatus = "returning1";
        break;
      case "returning1":
        text = "Trả hàng lần 2 không thành công";
        updateStatus = "returning2";
        break;
      case "returning2":
        text = "Trả hàng lần 3 không thành công";
        updateStatus = "returning3";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Status Update"),
      content: Consumer<OrderDetailProvider>(
        builder: (context, value, child) {
          return Text(text);
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Hủy"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Xác nhận"),
          onPressed: () {
            mProvider
                .updateOrder(
                widget.number, updateStatus, text)
                .listen((r) {
              LoginResponse res = LoginResponse.fromJson(r);
              if (res.result) {
                Navigator.pop(context);
                Toast.show("Thành công!");
                Navigator.pop(context, [updateStatus, widget.number]);
              } else
                Toast.show("Thất bại!");
            });
          },
        )
      ],
    );
  }
}
