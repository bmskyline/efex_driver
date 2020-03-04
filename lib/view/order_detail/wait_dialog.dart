import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_detail_provider.dart';

class WaitDialogPage extends PageProvideNode<OrderDetailProvider> {
  final String number;
  final String status;
  final String name;

  WaitDialogPage(this.number, this.status, this.name);

  @override
  Widget buildContent(BuildContext context) {
    return WaitDialogContent(mProvider, number, status, name);
  }
}

class WaitDialogContent extends StatefulWidget {
  final OrderDetailProvider provider;
  final String number;
  final String status;
  final String name;

  WaitDialogContent(this.provider, this.number, this.status, this.name);

  @override
  State<StatefulWidget> createState() => _WaitDialogContentState();
}

class _WaitDialogContentState extends State<WaitDialogContent> {
  OrderDetailProvider mProvider;
  String text;
  String updateStatus;
  String reason;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    switch(widget.status) {
      case "picking":
        text = "Lấy hàng lần 1 không thành công";
        updateStatus = "picking1";
        reason = "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã đến shop ${widget.name} lấy hàng lần 1 không thành công";
        break;
      case "picking1":
        text = "Lấy hàng lần 2 không thành công";
        updateStatus = "picking2";
        reason = "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã đến shop ${widget.name} lấy hàng lần 2 không thành công";
        break;
      case "picking2":
        text = "Lấy hàng lần 3 không thành công";
        updateStatus = "picking3";
        reason = "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã đến shop ${widget.name} lấy hàng lần 3 không thành công";
        break;
      case "returning":
        text = "Trả hàng lần 1 không thành công";
        updateStatus = "returning1";
        reason = "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã đến shop ${widget.name} trả hàng lần 1 không thành công";
        break;
      case "returning1":
        text = "Trả hàng lần 2 không thành công";
        updateStatus = "returning2";
        reason = "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã đến shop ${widget.name} trả hàng lần 2 không thành công";
        break;
      case "returning2":
        text = "Trả hàng lần 3 không thành công";
        updateStatus = "returning3";
        reason = "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã đến shop ${widget.name} trả hàng lần 3 không thành công";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text),
      content: Consumer<OrderDetailProvider>(
        builder: (context, value, child) {
          return Container(
            width: double.infinity,
            color: Colors.white,
            child: TextField(
              maxLength: 100,
              style: TextStyle(color: Colors.black),
              maxLines: 3,
              onChanged: (value) => mProvider.waitReason = value,
              decoration: InputDecoration(
                  hintText: "Ghi chú!", fillColor: Colors.white),
            ),
          );
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
                widget.number, updateStatus, (mProvider.waitReason.isNotEmpty ? mProvider.waitReason : reason))
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
