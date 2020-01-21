import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/order_detail/order_detail_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends PageProvideNode<OrderDetailProvider> {
  final Order order;
  OrderDetailPage(this.order);

  @override
  Widget buildContent(BuildContext context) {
    return _OrderDetailContentPage(mProvider, order);
  }
}

class _OrderDetailContentPage extends StatefulWidget {
  final OrderDetailProvider provider;
  final Order order;
  _OrderDetailContentPage(this.provider, this.order);

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
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    mProvider.image = image;
  }

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    Future.delayed(const Duration(milliseconds: 4000), () {
      setState(() {
        for (int i = 0; i < 20; i++) {
          order.products.add(order.products[0]);
        }
      });
    });
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
                Container(
                  width: double.infinity,
                  color: primaryColorHome,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8),
                          child: Text(order.fromName,
                              style: TextStyle(
                                  fontSize: 22, color: Colors.white))),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 8),
                        child: Text(
                            "Tổng sản phẩm: " +
                                order.fullCount +
                                " - Tổng trọng lượng: " +
                                order.weightOfProduct().toString() +
                                "g",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white60)),
                      ),
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
                CupertinoButton(
                  onPressed: () => {},
                  color: Colors.orange,
                  borderRadius: new BorderRadius.circular(0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      "Xác nhận lấy hàng thành công",
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          buildProgress()
        ]));
  }

  Consumer<OrderDetailProvider> buildProgress() {
    return Consumer<OrderDetailProvider>(builder: (context, value, child) {
      return Visibility(
        child: const CircularProgressIndicator(),
        visible: value.loading,
      );
    });
  }
}
