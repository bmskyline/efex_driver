import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/detail/detail_page.dart';
import 'package:driver_app/view/home/pickup/pickup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupPage extends PageProvideNode<PickupProvider> {
  final BuildContext homeContext;
  PickupPage(this.homeContext);

  @override
  Widget buildContent(BuildContext context) {
    return _PickupContentPage(homeContext, mProvider);
  }
}

class _PickupContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final PickupProvider provider;
  _PickupContentPage(this.homeContext, this.provider);

  @override
  State<StatefulWidget> createState() {
    return _PickupContentState(homeContext);
  }
}

class _PickupContentState extends State<_PickupContentPage>
    with TickerProviderStateMixin<_PickupContentPage>,
    AutomaticKeepAliveClientMixin {
  BuildContext homeContext;

  _PickupContentState(this.homeContext);

  PickupProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    print("tao lai cai moi roi oop! pickup");
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
    return SizedBox.expand(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!mProvider.loading &&
              mProvider.page * mProvider.limit < mProvider.total &&
              scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
            _loadData();
          }
        },
        child:
        Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          Consumer<PickupProvider>(builder: (context, value, child) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: value.shops == null ? 0 : value.shops.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    child: Card(
                      color: secondColorHome,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              homeContext,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(value.shops[index]),
                              ),
                            );
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  value.shops[index].fromName,
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(
                                      fontSizeFactor: 1.5,
                                      color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 8),
                                Row(children: <Widget>[
                                  Icon(Icons.location_on,
                                      size: 20, color: Colors.white60),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      value.shops[index].fromAddress,
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(
                                          fontSizeFactor: 1.2,
                                          color: Colors.white60),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ]),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.phone,
                                        size: 20, color: Colors.white60),
                                    SizedBox(width: 16),
                                    Text(
                                      value.shops[index].fromPhone,
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(
                                          fontSizeFactor: 1.2,
                                          color: Colors.white60),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.border_color,
                                        size: 20, color: Colors.white60),
                                    SizedBox(width: 16),
                                    Text(
                                      value.shops[index].totalOrders
                                          .toString() +
                                          " orders",
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(
                                          fontSizeFactor: 1.2,
                                          color: Colors.white60),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time,
                                        size: 20, color: Colors.white60),
                                    SizedBox(width: 16),
                                    Text(
                                      value.shops[index].fullCount,
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(
                                          fontSizeFactor: 1.2,
                                          color: Colors.white60),
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          buildProgress()
        ]),
      ),
    );
  }

  Consumer<PickupProvider> buildProgress() {
    return Consumer<PickupProvider>(builder: (context, value, child) {
      return Visibility(
        child: const CircularProgressIndicator(),
        visible: value.loading,
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
