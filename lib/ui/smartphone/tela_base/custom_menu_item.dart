import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';


import '../../../config.dart';
import '../../../common/common.dart';

class CustomMenuItem extends StatelessWidget {
  CustomMenuItem(this.icon, this.titulo, this.function, {this.isSelect = false});

  Widget icon;
  String titulo;
  VoidCallback function;
  bool isSelect;

  @override
  Widget build(BuildContext context) {
    return kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            border: isSelect ? Border.all(color: Config.corPri) : null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
              children: [
                IconTheme(
                    data: IconThemeData(
                      color: isSelect ? Config.corPri :  Colors.white, size: 20
                    ),
                    child: icon
                ),
                const SizedBox(width: 10,),
                Text(titulo, style: TextStyle(fontSize: 13,
                    color: isSelect ? Config.corPri : Colors.white,
                    fontWeight: isSelect ? FontWeight.bold : FontWeight.normal),),
              ]
          ),
        ),
      ),
    ) : Container(
      width: 115,
      child: Column(
        children: [
          InkWell(
            onTap: function,
            child:  Container(
              padding: EdgeInsets.all(10),
              height: 70, width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Config.corPri
              ),
              child: IconTheme(
                  data: IconThemeData(color: Colors.white, size: 40),
                  child: icon
              ),
            ),
          ),
          if(kIsWeb)
            SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: CustomText.text(titulo, textAlign: TextAlign.center, autoSize: true,
                style: TextStyle(height: 0)),
          )
        ],
      ),
    );
  }

}

