import 'package:driver_app/base/base.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/home/cancel/cancel_page.dart';
import 'package:driver_app/view/home/home_provider.dart';
import 'package:driver_app/view/home/new/new_page.dart';
import 'package:driver_app/view/home/success/success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'destination_model.dart';

const List<Destination> allDestinations = <Destination>[
  Destination(0, 'New', Icons.fiber_new, Colors.blue),
  Destination(1, 'Success', Icons.done_outline, Colors.orange),
  Destination(2, 'Cancel', Icons.cancel, Colors.red),
];

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
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            children: <Widget>[
              Offstage(
                offstage: value.currentIndex != 0,
                child: NewPage(context),
              ),
              Offstage(
                offstage: value.currentIndex != 1,
                child: SuccessPage(context),
              ),
              Offstage(
                offstage: value.currentIndex != 2,
                child: CancelPage(context),
              )
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

  @override
  bool get wantKeepAlive => true;
}
