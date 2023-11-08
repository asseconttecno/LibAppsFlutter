

import 'package:flutter/cupertino.dart';

ExpandedOrContainer({
  Key? key,
  bool isContainer = true,
  required Widget child,
  double? height,
  double? width
}){
  return isContainer ? Container(
    key: key, height: height, width: width,
    child: child,
  ) : Expanded(key: key, child: child);
}