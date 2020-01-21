import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/home/new/new_provider.dart';
import 'package:driver_app/view/home/pickup/pickup_page.dart';
import 'package:driver_app/view/home/return/return_page.dart';
import 'package:driver_app/view/login/login_page.dart';
import 'package:flutter/material.dart';

class NewPage extends PageProvideNode<NewProvider> {
  final BuildContext homeContext;
  NewPage(this.homeContext);

  @override
  Widget buildContent(BuildContext context) {
    return _NewContentPage(homeContext, mProvider);
  }
}

class _NewContentPage extends StatefulWidget {
  final BuildContext homeContext;
  final NewProvider provider;
  _NewContentPage(this.homeContext, this.provider);

  @override
  State<StatefulWidget> createState() {
    return _NewContentState(homeContext);
  }
}

class _NewContentState extends State<_NewContentPage>
    with TickerProviderStateMixin<_NewContentPage> {

  final BuildContext homeContext;
  ScrollController _scrollViewController;
  TabController _tabController;
  _NewContentState(this.homeContext);

  NewProvider mProvider;

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
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
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
                PickupPage(homeContext, "new"),
                ReturnPage(homeContext,  "new")
              ],
              controller: _tabController,
            )));
  }
}
