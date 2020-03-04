import 'package:driver_app/base/base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_list_provider.dart';

class AddDialogPage extends PageProvideNode<OrderListProvider> {

  @override
  Widget buildContent(BuildContext context) {
    return AddDialogContent(mProvider);
  }
}

class AddDialogContent extends StatefulWidget {
  final OrderListProvider provider;

  AddDialogContent(this.provider);

  @override
  State<StatefulWidget> createState() => _AddDialogContentState();
}

class _AddDialogContentState extends State<AddDialogContent> {
  OrderListProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Thêm đơn hàng"),
      content: Consumer<OrderListProvider>(
        builder: (context, value, child) {
          return Container(
            width: double.infinity,
            color: Colors.white,
            child: TextField(
              maxLength: 100,
              style: TextStyle(color: Colors.black),
              maxLines: 3,
              onChanged: (value) => {},
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

          },
        )
      ],
    );
  }
}
