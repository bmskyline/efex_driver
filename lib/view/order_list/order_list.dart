import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/order_detail/order_detail_provider.dart';
import 'package:driver_app/view/order_list/order_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OrderListPage extends PageProvideNode<OrderListProvider> {
  final List<Order> orders;
  OrderListPage(this.orders);

  @override
  Widget buildContent(BuildContext context) {
    return _OrderListContentPage(mProvider, orders);
  }
}

class _OrderListContentPage extends StatefulWidget {
  final OrderListProvider provider;
  final List<Order> orders;
  _OrderListContentPage(this.provider, this.orders);

  @override
  State<StatefulWidget> createState() {
    return _OrderListState(orders);
  }
}

class _OrderListState extends State<_OrderListContentPage>
    with TickerProviderStateMixin<_OrderListContentPage> {
  OrderListProvider mProvider;
  List<Order> orders;
  _OrderListState(this.orders);

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
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
          title: Image.asset('assets/logo_hor.png', fit: BoxFit.cover),
        ),
        body: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        orders == null ? 0 : orders.length,
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
                                orders[index].trackingNumber,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    maxLines: 4,
                    onChanged: (value) => print(value),
                    decoration: InputDecoration(
                        hintText: "Ghi chú!", fillColor: Colors.white),
                  ),
                ),
                Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 16),
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
                  child: CupertinoButton(
                    onPressed: () => {},
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(0),
                    child: Text(
                      "Xác nhận",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
}
