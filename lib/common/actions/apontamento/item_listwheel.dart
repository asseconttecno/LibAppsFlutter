
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/common.dart';
import '../../../config.dart';
import '../../../model/model.dart';

Widget ItemListWheel(BuildContext context, Apontamento aponta, bool selecionado) {

  return Card(
      elevation: 4,
      color: selecionado ? Config.corPri : null,
      //margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: CustomText.text(
          aponta.descricao?.toUpperCase() ?? "",
          style: TextStyle(
            fontSize: 20,
            //color: Colors.black
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: 2,
        ),
      )
  );
}
