

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget CustomContainer({required Widget child, Color? color, bool center = true, double margin = 8,
  double borderRadius = 8, bool isBorder = false, Color? borderColor, GlobalKey? key, bool isExtend = false,
  double? height, double? width, double padding = 10, bool ispadding = true, bool isMargin = false, }){
  return Container(
    key: key,
    height: height,
    width: width,
    padding: ispadding ? EdgeInsets.all(padding) : EdgeInsets.zero,
    margin: isMargin ? EdgeInsets.symmetric(horizontal: margin) : EdgeInsets.zero,
    decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        border: isBorder ? Border.all(color: borderColor ?? color ?? Colors.grey) : null
    ),
    alignment: center ? Alignment.center : null,
    child: _ExpandContainer(isExtend, child),
  );
}

_ExpandContainer(bool expand, Widget child){
  return expand ?
  Expanded(
      child: child
  ):
  Container(
    child: child,
  );
}