import 'package:flutter/material.dart';

customSnackbar(String text, Color cor, GlobalKey<ScaffoldState> scaffoldKey){
  ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
    backgroundColor: cor,
    duration: Duration(seconds: 3),
    content: Text(text, style: TextStyle(color: Colors.white),),
  ));
}