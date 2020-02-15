import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_detail_provider.dart';

class DialogPage extends PageProvideNode<OrderDetailProvider> {
  final String number;
  final int type;

  DialogPage(this.number, this.type);

  @override
  Widget buildContent(BuildContext context) {
    return DialogContent(mProvider, number, type);
  }
}

class DialogContent extends StatefulWidget {
  final OrderDetailProvider provider;
  final String number;
  final int type;

  DialogContent(this.provider, this.number, this.type);

  @override
  State<StatefulWidget> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  OrderDetailProvider mProvider;
  static const Map<String, String> itemsPick = {
    "picking_fail": "Không lấy được hàng sau 3 lần",
    "picking_fail_by_shop": "Shop từ chối giao hàng",
  };
  static const Map<String, String> itemsReturn = {
    "return_fail": "Không trả được hàng sau 3 lần",
    "return_fail_by_shop": "Shop từ chối nhận hàng",
  };

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Status Update"),
      content: Consumer<OrderDetailProvider>(
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                isExpanded: true,
                hint: Text("Status"),
                value: widget.type == 1 ? value.selectedPick: value.selectedReturn,
                items: (widget.type == 1 ? itemsPick : itemsReturn)
                    .map((key, value) {
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
                  widget.type == 1 ? value.selectedPick = val : value.selectedReturn = val;
                },
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: TextField(
                  maxLines: 4,
                  onChanged: (value) => mProvider.reason = value,
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
                widget.number, widget.type == 1 ? mProvider.selectedPick : mProvider.selectedReturn, mProvider.reason)
                .listen((r) {
              LoginResponse res = LoginResponse.fromJson(r);
              if (res.result) {
                Navigator.pop(context);
                Toast.show("Hủy đơn hàng thành công!");
                Navigator.pop(context, [true, widget.number]);
              } else
                Toast.show("Hủy đơn hàng thất bại!");
            });
          },
        )
      ],
    );
  }
}
