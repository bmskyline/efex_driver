import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_detail_provider.dart';

class DialogPage extends PageProvideNode<OrderDetailProvider> {
  final String number;
  final int type;
  final String status;
  final String name;

  DialogPage(this.number, this.type, this.status, this.name);

  @override
  Widget buildContent(BuildContext context) {
    return DialogContent(mProvider, number, type, status, name);
  }
}

class DialogContent extends StatefulWidget {
  final OrderDetailProvider provider;
  final String number;
  final int type;
  final String status;
  final String name;

  DialogContent(this.provider, this.number, this.type, this.status, this.name);

  @override
  State<StatefulWidget> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  OrderDetailProvider mProvider;
  Map<String, String> items = {};

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    switch(widget.type) {
      case 1:
        if(widget.status == "picking3"){
          items.addAll({
            "picking_fail_by_shop": "Shop từ chối giao hàng",
            "picking_fail": "Không lấy được hàng sau 3 lần",
          });
        } else {
          items.addAll({
            "picking_fail_by_shop": "Shop từ chối giao hàng",
          });
        }
        mProvider.selected = "picking_fail_by_shop";
        break;
      case 2:
        if(widget.status == "returning3"){
          items.addAll({
            "return_fail_by_shop": "Shop từ chối nhận hàng",
            "return_fail": "Không trả được hàng sau 3 lần",
          });
        } else {
          items.addAll({
            "return_fail_by_shop": "Shop từ chối nhận hàng",
          });
        }
        mProvider.selected = "return_fail_by_shop";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Hủy đơn hàng"),
      content: Consumer<OrderDetailProvider>(
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                isExpanded: true,
                hint: Text("Status"),
                value: value.selected,
                items: items.map((key, value) {
                  return MapEntry(
                      key,
                      DropdownMenuItem<String>(
                        value: key,
                        child: Text(value),
                      ));
                })
                    .values
                    .toList(),
                onChanged: (String val) {
                  value.selected = val;
                },
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: TextField(
                  maxLines: 4,
                  onChanged: (value) => mProvider.cancelReason = value,
                  decoration: InputDecoration(
                      hintText: "Ghi chú!", fillColor: Colors.white),
                ),
              ),
            ],
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
                widget.number, mProvider.selected, (mProvider.cancelReason.isNotEmpty ? mProvider.cancelReason : "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã hủy đơn hàng ${widget.number} vì ${items[mProvider.selected]} tại shop ${widget.name}"))
                .listen((r) {
              LoginResponse res = LoginResponse.fromJson(r);
              if (res.result) {
                Navigator.pop(context);
                Toast.show("Hủy đơn hàng thành công!");
                Navigator.pop(context, ["fail", widget.number]);
              } else
                Toast.show("Hủy đơn hàng thất bại!");
            });
          },
        )
      ],
    );
  }
}
