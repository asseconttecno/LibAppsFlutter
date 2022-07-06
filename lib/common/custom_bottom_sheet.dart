import 'package:flutter/material.dart';

CustomBottomSheet(BuildContext context, Widget body, bool expanded){

  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder:(context) => body,
      constraints: expanded ? BoxConstraints.expand() : null,
      isScrollControlled: expanded
  );
}