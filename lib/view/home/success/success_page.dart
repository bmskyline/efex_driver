import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/home/pickup/pickup_page.dart';
import 'package:driver_app/view/home/return/return_page.dart';
import 'package:driver_app/view/home/success/success_provider.dart';
import 'package:driver_app/view/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuccessPage extends PageProvideNode<SuccessProvider> {
  final BuildContext homeContext;
  SuccessPage(this.homeContext);

  @override
  Widget buildContent(BuildContext context) {
    return _SuccessContentPage(homeContext, mProvider);
  }
}

class _SuccessContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final SuccessProvider provider;

  _SuccessContentPage(this.homeContext, this.provider);

  @override
  State<StatefulWidget> createState() {
    return _SuccessContentState(homeContext);
  }
}

class _SuccessContentState extends State<_SuccessContentPage>
    with TickerProviderStateMixin<_SuccessContentPage> {
  final BuildContext homeContext;
  ScrollController _scrollViewController;
  TabController _tabController;
  _SuccessContentState(this.homeContext);

  SuccessProvider mProvider;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _tabController = TabController(vsync: this, length: 2);
    mProvider = widget.provider;
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        body: NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  backgroundColor: primaryColorHome,
                  title: Image.asset('assets/logo_hor.png', fit: BoxFit.cover),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: <Widget>[
                    // action button
                    IconButton(
                      icon: Icon(Icons.power_settings_new, color: Colors.white),
                      onPressed: () {
                        mProvider.removeToken();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    ),
                  ],
                  bottom: TabBar(
                    indicatorColor: indicatorHome,
                    tabs: [Tab(text: "Lấy hàng"), Tab(text: "Trả hàng")],
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                PickupPage(homeContext),
                ReturnPage(homeContext)
              ],
              controller: _tabController,
            )));
  }
/* SizedBox.expand(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!mProvider.loading &&
                          mProvider.page * mProvider.limit < mProvider.total &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        _loadData();
                      }
                    },
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Consumer<SuccessProvider>(
                              builder: (context, value, child) {
                            return MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount:
                                    value.shops == null ? 0 : value.shops.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    child: Card(
                                      color: secondColorHome,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              homeContext,
                                              MaterialPageRoute(
                                                builder: (context) => DetailPage(
                                                    value.shops[index]),
                                              ),
                                            );
                                          },
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  value.shops[index].fromName,
                                                  style:
                                                      DefaultTextStyle.of(context)
                                                          .style
                                                          .apply(
                                                              fontSizeFactor: 1.5,
                                                              color:
                                                                  Colors.white),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                SizedBox(height: 8),
                                                Row(children: <Widget>[
                                                  Icon(Icons.location_on,
                                                      size: 20,
                                                      color: Colors.white60),
                                                  SizedBox(width: 16),
                                                  Expanded(
                                                    child: Text(
                                                      value.shops[index]
                                                          .fromAddress,
                                                      style: DefaultTextStyle.of(
                                                              context)
                                                          .style
                                                          .apply(
                                                              fontSizeFactor: 1.2,
                                                              color:
                                                                  Colors.white60),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ]),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(Icons.phone,
                                                        size: 20,
                                                        color: Colors.white60),
                                                    SizedBox(width: 16),
                                                    Text(
                                                      value
                                                          .shops[index].fromPhone,
                                                      style: DefaultTextStyle.of(
                                                              context)
                                                          .style
                                                          .apply(
                                                              fontSizeFactor: 1.2,
                                                              color:
                                                                  Colors.white60),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(Icons.border_color,
                                                        size: 20,
                                                        color: Colors.white60),
                                                    SizedBox(width: 16),
                                                    Text(
                                                      value.shops[index]
                                                              .totalOrders
                                                              .toString() +
                                                          " orders",
                                                      style: DefaultTextStyle.of(
                                                              context)
                                                          .style
                                                          .apply(
                                                              fontSizeFactor: 1.2,
                                                              color:
                                                                  Colors.white60),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(Icons.access_time,
                                                        size: 20,
                                                        color: Colors.white60),
                                                    SizedBox(width: 16),
                                                    Text(
                                                      value
                                                          .shops[index].fullCount,
                                                      style: DefaultTextStyle.of(
                                                              context)
                                                          .style
                                                          .apply(
                                                              fontSizeFactor: 1.2,
                                                              color:
                                                                  Colors.white60),
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
                ),*/
}
