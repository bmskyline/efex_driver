import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/scan/custom_search.dart';
import 'package:driver_app/view/scan/list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends PageProvideNode<ListProvider> {
  final List<Order> orders;

  ListPage(this.orders, List<String> result) {
    mProvider.addList(result);
  }

  @override
  Widget buildContent(BuildContext context) {
    return _ListContentPage(mProvider, orders);
  }

}

class _ListContentPage extends StatefulWidget{
  final ListProvider provider;
  final List<Order> orders;

  _ListContentPage(this.provider, this.orders);

  @override
  State<StatefulWidget> createState() {
    return ListContentState();
  }
}

class ListContentState extends State<_ListContentPage>
    with TickerProviderStateMixin<_ListContentPage>{

  ListProvider provider;

  @override
  void initState() {
    super.initState();
    provider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorHome,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColorHome,
          title: Image.asset('assets/logo_hor.png',
              fit: BoxFit.fitHeight, height: 32),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(provider, widget.orders),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Consumer<ListProvider>(builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.white, thickness: 0.5,);
                    },
                    itemCount: widget.orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){
                          value.list.contains(widget.orders[index].trackingNumber)
                              ? value.remove(widget.orders[index].trackingNumber)
                              : value.add(widget.orders[index].trackingNumber);
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.orders[index].trackingNumber,
                                style: TextStyle(color: Colors.white, fontSize: 22),
                              ),
                            ),
                            Checkbox(
                              value: value.list.contains(widget.orders[index].trackingNumber),
                              checkColor: Colors.white,
                              onChanged: null,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
            Consumer<ListProvider>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.list.isEmpty ? false : true,
                  child: Container(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context, value.list.toList());
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