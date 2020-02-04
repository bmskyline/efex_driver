import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/home/pickup/pickup_page.dart';
import 'package:driver_app/view/home/return/return_page.dart';
import 'package:driver_app/view/home/success/success_provider.dart';
import 'package:flutter/material.dart';

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
                    tabs: [Tab(text: "Lấy hàng"), Tab(text: "Trả hàng")],
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                PickupPage(homeContext, "picked"),
                ReturnPage(homeContext, "picked")
              ],
              controller: _tabController,
            )));
  }
}
