import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return kIsWeb ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            border: isSelect ? Border.all(color: Config.corPribar) : null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: isSelect ? Config.corPribar.withOpacity(0.2) : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
              children: [
                icon,
                const SizedBox(width: 10,),
                Text(titulo, style: TextStyle(fontSize: 13, color: Colors.white,
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
              child: icon,
            ),
          ),
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

