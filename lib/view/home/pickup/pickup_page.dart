import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/home/cancel/cancel_page.dart';
import 'package:driver_app/view/home/new/new_page.dart';
import 'package:driver_app/view/home/pickup/pickup_provider.dart';
import 'package:driver_app/view/home/success/success_page.dart';
import 'package:flutter/material.dart';

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
    with
        TickerProviderStateMixin<_PickupContentPage>,
        AutomaticKeepAliveClientMixin {
  final BuildContext homeContext;
  ScrollController _scrollViewController;
  TabController _tabController;
  _PickupContentState(this.homeContext);

  PickupProvider mProvider;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _tabController = TabController(vsync: this, length: 3);
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
    super.build(context);
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
                  title: Image.asset('assets/logo_hor.png', fit: BoxFit.fitHeight, height: 30),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: <Widget>[
                    // action button
                    IconButton(
                      icon: Icon(Icons.power_settings_new, color: Colors.white),
                      onPressed: () {
                        mProvider.logout().listen((data) {
                          LoginResponse res = LoginResponse.fromJson(data);
                          if (res.result) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false);
                          }
                        });
                      },
                    ),
                  ],
                  bottom: TabBar(
                    indicatorColor: indicatorHome,
                    tabs: [
                      Tab(text: "Mới"),
                      Tab(text: "Thành công"),
                      Tab(text: "Hủy")
                    ],
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                NewPage(homeContext, 1),
                SuccessPage(homeContext, 1),
                CancelPage(homeContext, 1)
              ],
              controller: _tabController,
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
