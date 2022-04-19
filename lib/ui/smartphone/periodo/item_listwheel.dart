
import '../../../model/apontamento/apontamento.dart';
import '../../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget ItemListWheel(BuildContext context, Apontamento aponta, bool selecionado) {

  return Card(
      elevation: 4,
      color: selecionado ? Settings.corPri : null,
      //margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: Text(
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
