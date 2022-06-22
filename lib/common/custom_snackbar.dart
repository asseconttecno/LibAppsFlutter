import 'package:flutter/material.dart';

class CustomSnackbar {

  static scaffoldKey(GlobalKey<ScaffoldState> scaffoldKey, String text, Color cor, ){
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
      backgroundColor: cor,
      duration: Duration(seconds: 3),
      content: Text(text, style: TextStyle(color: Colors.white),),
    ));
  }

  static context(BuildContext context, String text, Color cor){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: cor,
      duration: Duration(seconds: 3),
      content: Text(text, style: TextStyle(color: Colors.white),),
    ));
  }
}