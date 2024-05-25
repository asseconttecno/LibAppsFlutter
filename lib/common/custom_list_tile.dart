

import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.child, this.height = 80, this.padding});
  final Widget child;
  final double height;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
            child: child,
          )
      ),
    );
  }
}
