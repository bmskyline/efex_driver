import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends PageProvideNode<DetailProvider> {

  @override
  Widget buildContent(BuildContext context) {
    return _DetailContentPage(mProvider);
  }
}

class _DetailContentPage extends StatefulWidget {
  final DetailProvider provider;

  _DetailContentPage(this.provider);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<_DetailContentPage>
      with TickerProviderStateMixin<_DetailContentPage>{

  DetailProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Consumer<DetailProvider>(
        builder: (context, value, child) {
          return Column(
            children: <Widget>[
              Text("scan screen"+ value.response.name),
              Text("scan screen"+ value.response.orders.length.toString()),
            ],
          );
        }
      ),
    );
  }

  void _loadData() {
    final s =
    mProvider.getShopDetail().doOnListen(() {}).doOnDone(() {}).listen((data) {
      //success
    }, onError: (e) {
      //error
      dispatchFailure(context, e);
    });
    mProvider.addSubscription(s);
  }
}
