import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cancel_provider.dart';

class CancelPage extends PageProvideNode<CancelProvider> {
  final BuildContext homeContext;
  CancelPage(this.homeContext);

  @override
  Widget buildContent(BuildContext context) {
    return _CancelContentPage(homeContext, mProvider);
  }
}

class _CancelContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final CancelProvider provider;
  _CancelContentPage(this.homeContext, this.provider);

  @override
  State<StatefulWidget> createState() {
    return _CancelContentState(homeContext);
  }
}

class _CancelContentState extends State<_CancelContentPage>
    with TickerProviderStateMixin<_CancelContentPage> {
  BuildContext homeContext;

  _CancelContentState(this.homeContext);

  CancelProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    _loadData();
  }

  void _loadData() {
    final s =
        mProvider.getShops().doOnListen(() {}).doOnDone(() {}).listen((data) {
      //success
    }, onError: (e) {
      //error
      dispatchFailure(context, e);
    });
    mProvider.addSubscription(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SizedBox.expand(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!mProvider.loading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadData();
            }
          },
          child:
              Stack(alignment: AlignmentDirectional.center, children: <Widget>[
            Consumer<CancelProvider>(builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.response == null
                    ? 0
                    : value.response.data.shops.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    child: Card(
                      color: Colors.blue[50].withOpacity(0.25),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              homeContext,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(),
                              ),
                            );
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  value.response.data.shops[index].fromName,
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.5),
                                ),
                                SizedBox(height: 8),
                                Row(children: <Widget>[
                                  Icon(Icons.location_on, size: 20),
                                  SizedBox(width: 16),
                                  Text(
                                      value.response.data.shops[index]
                                          .fromAddress,
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 1.2)),
                                ]),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.phone, size: 20),
                                    SizedBox(width: 16),
                                    Text(
                                      value
                                          .response.data.shops[index].fromPhone,
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 1.2),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.border_color, size: 20),
                                    SizedBox(width: 16),
                                    Text(
                                      value.response.data.shops[index]
                                              .totalOrders
                                              .toString() +
                                          " orders",
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 1.2),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time, size: 20),
                                    SizedBox(width: 16),
                                    Text(
                                      value
                                          .response.data.shops[index].fullCount,
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 1.2),
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
            buildProgress()
          ]),
        ),
      ),
    );
  }

  Consumer<CancelProvider> buildProgress() {
    return Consumer<CancelProvider>(builder: (context, value, child) {
      return Visibility(
        child: CircularProgressIndicator(),
        visible: value.loading,
      );
    });
  }
}
