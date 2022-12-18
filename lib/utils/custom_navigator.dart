

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomNavigator {

  static dynamic pop(BuildContext context, {dynamic result}) {
    return Navigator.pop(context, result);
  }

  static popHome(BuildContext context, {Object? arguments}){
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  static Future routeClass(BuildContext context, Widget classe) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => classe, ),
    );
  }

  static Future named(BuildContext context, String rota, {Object? arguments}) async {
    return await Navigator.pushNamed(context, rota, arguments: arguments);
  }

  static namedRemovePages(BuildContext context, String rota, {Object? arguments}){
    Navigator.pushNamedAndRemoveUntil(context, rota, (Route<dynamic> route) => false, arguments: arguments);
  }

  static namedSubtituirTodasPage(BuildContext context, String rota, {Object? arguments}){
    Navigator.pushNamedAndRemoveUntil(context, rota,  (Route<dynamic> route) => route.isFirst, arguments: arguments);
  }

  static namedSubtituirPage(BuildContext context, String rota, {Object? arguments}){
    Navigator.popAndPushNamed(context, rota, arguments: arguments);
  }

}