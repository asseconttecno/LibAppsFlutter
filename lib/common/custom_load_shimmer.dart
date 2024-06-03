import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../config.dart';


class CustomShimmerLoad extends StatelessWidget {
  CustomShimmerLoad({super.key, this.isLoad = false, required this.child});
  final bool isLoad;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return  isLoad ? Shimmer.fromColors(
        baseColor: context.watch<Config>().darkTemas ?  Colors.grey[800]! : Colors.grey.shade200,
        highlightColor: context.watch<Config>().darkTemas ?  Colors.grey[600]! : Colors.grey,
        child: child
    ) : child;
  }
}
