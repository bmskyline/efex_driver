import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/utils/toast_utils.dart';
import 'package:driver_app/utils/widget_utils.dart';
import 'package:driver_app/view/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_provider.dart';

class LoginPage extends PageProvideNode<LoginProvider> {
  @override
  Widget buildContent(BuildContext context) {
    return _LoginContentPage(mProvider);
  }
}

class _LoginContentPage extends StatefulWidget {
  final LoginProvider provider;

  _LoginContentPage(this.provider);

  @override
  State<StatefulWidget> createState() {
    return _LoginContentState();
  }
}

class _LoginContentState extends State<_LoginContentPage>
    with TickerProviderStateMixin<_LoginContentPage>
    implements Presenter {
  LoginProvider mProvider;
  AnimationController _controller;
  Animation<double> _animation;
  final focus = FocusNode();
  static const ACTION_LOGIN = "login";

  @override
  void initState() {
    super.initState();

    mProvider = widget.provider;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 295.0, end: 48.0).animate(_controller)
      ..addListener(() {
        mProvider.btnWidth = _animation.value;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void onClick(String action) {
    if (ACTION_LOGIN == action) {
      if (mProvider.userName.isEmpty) {
        Toast.show("Bạn chưa nhập số điện thoại!");
      } else if (mProvider.password.isEmpty) {
        Toast.show("Bạn chưa nhập mật khẩu!");
      } else {
        login();
      }
    }
  }

  void login() {
    final s = mProvider.login().doOnListen(() {
      _controller.forward();
    }).doOnDone(() {
      _controller.reverse();
    }).listen((_) {
      //success
      LoginResponse res = LoginResponse.fromJson(_);
      if (res.result) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Toast.show(res.msg);
      }
    }, onError: (e) {
      //error
      dispatchFailure(context, e);
    });
    mProvider.addSubscription(s);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("assets/bg.png"),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.black),
                    child: Column(
                      children: <Widget>[
                        const Padding(padding: EdgeInsets.only(top: 160.0)),
                        Image(
                          image: AssetImage('assets/logo.png'),
                          width: 120,
                          height: 120,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 128.0)),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 64.0, right: 64.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: primaryColor, width: 2.0)),
                          child: Column(
                            children: <Widget>[
                              Consumer<LoginProvider>(
                                  builder: (context, value, child) {
                                return TextField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      hintText: '0999999999',
                                      hintStyle: TextStyle(color: Colors.black54)
                                    ),
                                    onSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus);
                                    },
                                    autofocus: false,
                                    onChanged: (str) => value.userName = str);
                              }),
                              Consumer<LoginProvider>(
                                  builder: (context, value, child) {
                                return TextField(
                                    style: TextStyle(color: Colors.black),
                                    focusNode: focus,
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: primaryColor),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(color: Colors.black45)
                                    ),
                                    autofocus: false,
                                    onChanged: (str) => value.password = str);
                              }),
                            ],
                          ),
                        ),
                        buildLoginBtnProvide()
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    ));
  }

  Consumer<LoginProvider> buildLoginBtnProvide() {
    return Consumer<LoginProvider>(
      builder: (context, value, child) {
        return CupertinoButton(
          padding: EdgeInsets.only(left: 64.0, right: 64.0, top: 16.0),
          onPressed: value.loading ? null : () => onClick(ACTION_LOGIN),
          pressedOpacity: 0.8,
          child: Container(
            alignment: Alignment.center,
            width: value.btnWidth,
            height: 48,
            decoration: BoxDecoration(color: primaryColor),
            child: buildLoginChild(value),
          ),
        );
      },
    );
  }

  Widget buildLoginChild(LoginProvider value) {
    if (value.loading) {
      return const CircularProgressIndicator();
    } else {
      return FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          'Login',
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
        ),
      );
    }
  }
}
