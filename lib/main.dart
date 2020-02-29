import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/home/home_page.dart';
import 'package:driver_app/view/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'di/app_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  Provider.debugCheckInvalidValueType = null;
  Widget _defaultHome = LoginPage();
  if (spUtil.getString("TOKEN") != null && spUtil.getString("TOKEN") != "") {
    _defaultHome = HomePage();
  }
  runApp(MyApp(
    _defaultHome,
  ));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;
  MyApp(this.defaultHome);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Efex Driver',
      home: defaultHome,
      theme: ThemeData(
        primaryColor: primaryColorHome,
        accentColor: Colors.white,

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: "/",
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}
