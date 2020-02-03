import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/home/pickup/pickup_page.dart';
import 'package:driver_app/view/home/return/return_page.dart';
import 'package:flutter/material.dart';

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
  final BuildContext homeContext;
  ScrollController _scrollViewController;
  TabController _tabController;
  _CancelContentState(this.homeContext);

  CancelProvider mProvider;

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
                        mProvider.logout().listen(
                                (data) {
                              LoginResponse res = LoginResponse.fromJson(data);
                              if(res.result) {
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                              }
                            }
                        );
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
                PickupPage(homeContext, "fail"),
                ReturnPage(homeContext, "fail")
              ],
              controller: _tabController,
            )));
  }
}
