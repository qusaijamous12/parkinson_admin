import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parknson_admin/shared/color_manager.dart';


class Utils{

  static void hideKeyboard(context){
    FocusScope.of(context).requestFocus(FocusNode());
  }


  static Future<bool?> myToast({required String title}){
    return   Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorManager.kPrimary,
        textColor: Colors.white,
        webBgColor: 'linear-gradient(to right, #212b46, #212b46)',
        fontSize: 16.0
    );
  }

  static void printLog(Object? message) {
    if(kDebugMode) {
      debugPrint('🔹 $message');
    }
  }

}