

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ColumnOrRow extends StatelessWidget {
  const ColumnOrRow({super.key, required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.isColumn = true, this.isWrap = false,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool isColumn;
  final bool isWrap;

  @override
  Widget build(BuildContext context) {
    return isColumn
        ? Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        ) : isWrap
        ? Wrap(
          children: children,
        ) : Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        );
  }
}
