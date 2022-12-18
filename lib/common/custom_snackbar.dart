import 'package:flutter/material.dart';

import '../config.dart';
import 'common.dart';

class CustomSnackbar {

  static home(String text, Color cor){
    ScaffoldMessenger.of(Config.scaffoldKey.currentContext!).showSnackBar(SnackBar(
      backgroundColor: cor,
      duration: const Duration(seconds: 3),
      content: CustomText.text(text, style: const TextStyle(color: Colors.white),),
    ));
  }

  static scaffoldKey(GlobalKey<ScaffoldState> scaffoldKey, String text, Color cor, ){
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
      backgroundColor: cor,
      duration: const Duration(seconds: 3),
      content: CustomText.text(text, style: const TextStyle(color: Colors.white),),
    ));
  }

  static context(BuildContext context, String text, Color cor){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: cor,
      duration: const Duration(seconds: 3),
      content: CustomText.text(text, style: const TextStyle(color: Colors.white),),
    ));
  }
}