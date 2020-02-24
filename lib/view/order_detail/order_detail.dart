import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:driver_app/view/order_detail/order_detail_provider.dart';
import 'package:driver_app/view/order_detail/wait_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'cancel_dialog.dart';

class OrderDetailPage extends PageProvideNode<OrderDetailProvider> {
  final Order order;
  final String status;
  final int type;
  OrderDetailPage(this.order, this.status, this.type);

  @override
  Widget buildContent(BuildContext context) {
    return _OrderDetailContentPage(mProvider, order, status, type);
  }
}

class _OrderDetailContentPage extends StatefulWidget {
  final OrderDetailProvider provider;
  final Order order;
  final int type;
  final String status;
  _OrderDetailContentPage(this.provider, this.order, this.status, this.type);

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailState(order);
  }
}

class _OrderDetailState extends State<_OrderDetailContentPage>
    with TickerProviderStateMixin<_OrderDetailContentPage> {
  OrderDetailProvider mProvider;
  Order order;
  _OrderDetailState(this.order);

  Future getImage() async {
    FocusScope.of(context).unfocus(focusPrevious: true);
    var image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
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
          title: Image.asset('assets/logo_hor.png', fit: BoxFit.fitHeight, height: 32),
        ),
        body: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: primaryColorHome,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8),
                          child: Text(order.trackingNumber,
                              style: TextStyle(
                                  fontSize: 22, color: Colors.white))),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 8),
                          child: RichText(
                            text: TextSpan(
                              text: 'Tổng sản phẩm: ',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white60),
                              children: <TextSpan>[
                                TextSpan(
                                  text: order.products.length.toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                TextSpan(text: ' - Tổng trọng lượng: '),
                                TextSpan(
                                  text:
                                      order.weightOfProduct().toString() + 'g',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        order.products == null ? 0 : order.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.all(0),
                          color: secondColorHome,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                order.products[index].quantity.toString() +
                                    " x " +
                                    order.products[index].name,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                  width: double.infinity,
                  child: Text("Trạng thái: "+ statusMapping[order.currentStatus ?? ""],
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                  width: double.infinity,
                  child: Text("Thời gian: "+ (order.updatedTime != null ? DateFormat('dd-MM-yyyy HH:mm:ss').format(order.updatedTime) : ""),
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                  width: double.infinity,
                  child: Text("Ghi chú: " + (order.note ?? ""),
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                (widget.status == "fail" || widget.status == "picked") ?
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                  width: double.infinity,
                  child: Text("Tài xế: " + (order.reason ?? ""),
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ) : Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    maxLines: 4,
                    onChanged: (val) => mProvider.reason = val ,
                    decoration: InputDecoration(
                        hintText: "Tài xế: ", fillColor: Colors.white),
                  )
                ),
                Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 16),
                    color: Colors.white,
                    child: (widget.status == "fail" || widget.status == "picked")
                        ? (order.img.isNotEmpty ? Image.network(order.img) : Text("")) : InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: Consumer<OrderDetailProvider>(
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
                Row(children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 16.0),
                      child: Visibility(
                        visible: ((order.currentStatus == "picking"
                            || order.currentStatus == "picking1"
                            || order.currentStatus == "picking2"
                            || order.currentStatus == "returning"
                            || order.currentStatus == "returning1"
                            || order.currentStatus == "returning2")
                                && (widget.status != "fail"
                                    && widget.status != "picked")) ? true : false,
                        child: FlatButton(
                          onPressed: () => showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return WaitDialogPage(order.trackingNumber, order.currentStatus, order.fromName);
                              }),
                          color: Colors.red,
                          child: Text(
                            "Chờ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 16.0),
                      child: Visibility(
                        visible: (widget.status == "fail" || widget.status == "picked") ? false : true,
                        child: FlatButton(
                          onPressed: () => showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogPage(order.trackingNumber, widget.type, order.currentStatus, order.fromName);
                              }),
                          color: Colors.red,
                          child: Text(
                            "Hủy",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 32),
                  child: Consumer<OrderDetailProvider>(
                      builder: (context, value, child) {
                    return Visibility(
                      visible: (value.image == null || widget.status == "picked" || widget.status == "fail")
                          ? false
                          : true,
                      child: FlatButton(
                        onPressed: () {
                          mProvider
                              .updateOrder(order.trackingNumber, widget.type == 1 ? "picked" : "returned", (value.reason.isNotEmpty ? value.reason : (widget.type == 1 ? "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã lấy thành công đơn hàng ${order.trackingNumber} tại shop ${order.fromName}" :
                          "Nhân viên giao nhận ${mProvider.spUtil.getString("USER")} đã trả thành công đơn hàng ${order.trackingNumber} tại shop ${order.fromName}")))
                              .listen((r) {
                            LoginResponse res = LoginResponse.fromJson(r);
                            if (res.result) {
                              Toast.show("Xác nhận thành công!");
                              Navigator.pop(context, ["picked", order.trackingNumber]);
                            } else
                              Toast.show("Vui lòng thử lại!");
                          });
                        },
                        color: Colors.orange,
                        child: Text(
                          widget.type == 1 ?
                          "Xác Nhận Lấy Hàng Thành Công" : "Xác Nhận Trả Hàng Thành Công",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          buildProgress()
        ]));
  }

  Consumer<OrderDetailProvider> buildProgress() {
    return Consumer<OrderDetailProvider>(builder: (context, value, child) {
      return Visibility(
        child: Container(
          width: double.infinity,
            height: double.infinity,
            child: Center(
              child: const CircularProgressIndicator(),
            )),
        visible: value.loading,
      );
    });
  }
}