import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/home/home_provider.dart';
import 'package:driver_app/view/home/pickup/pickup_page.dart';
import 'package:driver_app/view/home/return/return_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'destination_model.dart';

class HomePage extends PageProvideNode<HomeProvider> {
  @override
  Widget buildContent(BuildContext context) {
    return _HomeContentPage(mProvider);
  }
}

class _HomeContentPage extends StatefulWidget {
  final HomeProvider provider;
  _HomeContentPage(this.provider);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<_HomeContentPage>
    with
        TickerProviderStateMixin<_HomeContentPage>,
        AutomaticKeepAliveClientMixin {
  HomeProvider mProvider;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return Scaffold(
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: value.currentIndex,
            children: <Widget>[
              PickupPage(context),
              ReturnPage(context),
            ],
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.white,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.white60))),
          child: BottomNavigationBar(
            backgroundColor: primaryColorHome,
            type: BottomNavigationBarType.fixed,
            currentIndex: value.currentIndex,
            onTap: (int index) {
              value.currentIndex = index;
            },
            items: allDestinations.map((Destination destination) {
              return BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  backgroundColor: destination.color,
                  title: Text(destination.title));
            }).toList(),
          ),
        ),
      );
    });
  }

  List<Destination> allDestinations = <Destination>[
    Destination(0, 'Lấy hàng', Icons.directions_bike, primaryColor),
    Destination(1, 'Trả hàng', Icons.assignment_return, primaryColor),
  ];

  @override
  bool get wantKeepAlive => true;
}
