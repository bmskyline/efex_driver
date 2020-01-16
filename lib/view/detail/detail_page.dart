import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends PageProvideNode<DetailProvider> {
  final Shop _shop;
  DetailPage(this._shop);

  @override
  Widget buildContent(BuildContext context) {
    return _DetailContentPage(mProvider, _shop);
  }
}

class _DetailContentPage extends StatefulWidget {
  final DetailProvider provider;
  final Shop _shop;

  _DetailContentPage(this.provider, this._shop);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<_DetailContentPage>
    with TickerProviderStateMixin<_DetailContentPage> {
  DetailProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    _loadData(widget._shop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Consumer<DetailProvider>(builder: (context, value, child) {
        return Column(
          children: <Widget>[
            Text(value.response.orders.toString(),
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.5, color: Colors.white)),
            Text(value.response.orders.toString(),
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.2, color: Colors.white)),
            Text(value.response.orders.toString(),
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.2, color: Colors.white)),
            ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    child: Card(
                      color: secondColorHome,
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Text tam thoi da",
                              style: DefaultTextStyle.of(context).style.apply(
                                  fontSizeFactor: 1.5, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              "Text tam thoi da",
                              style: DefaultTextStyle.of(context).style.apply(
                                  fontSizeFactor: 1.2, color: Colors.white60),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              "Text tam thoi da",
                              style: DefaultTextStyle.of(context).style.apply(
                                  fontSizeFactor: 1.2, color: Colors.white60),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              "Text tam thoi da",
                              style: DefaultTextStyle.of(context).style.apply(
                                  fontSizeFactor: 1.2, color: Colors.white60),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
          ],
        );
      }),
    );
  }

  void _loadData(Shop shop) {
    final s = mProvider
        .getShopDetail(shop)
        .doOnListen(() {})
        .doOnDone(() {})
        .listen((data) {
      //success
    }, onError: (e) {
      //error
      dispatchFailure(context, e);
    });
    mProvider.addSubscription(s);
  }
}
