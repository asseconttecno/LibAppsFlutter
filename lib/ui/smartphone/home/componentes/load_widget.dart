import 'package:provider/provider.dart';
import '../../../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerWidget(double width, BuildContext context)  {
  return Container(
    child: Shimmer.fromColors(
      baseColor: context.watch<Settings>().darkTemas ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: context.watch<Settings>().darkTemas ? Colors.grey : Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.026),
        child: Column(
            children:[
              SizedBox(height: 10,),
              Container(margin: EdgeInsets.only(bottom: 10,),
                color: Colors.black,
                height: 50,
              ),
              Container(margin: EdgeInsets.only(bottom: 10),
                color: Colors.black,
                height: 50,
              ),
              Container(margin: EdgeInsets.only(bottom: 10),
                color: Colors.black,
                height: 50,
              ),
            ]
        ),
      ),
    ),
  );
}