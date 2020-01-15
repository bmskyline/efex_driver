import 'package:driver_app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;

class Toast {
  static void show(String message) {
    toast.Fluttertoast.showToast(
        msg: message,
        toastLength: toast.Toast.LENGTH_SHORT,
        gravity: toast.ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
