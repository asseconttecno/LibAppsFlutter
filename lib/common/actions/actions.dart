import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../config.dart';
import 'func_aponta.dart';
import 'func_config.dart';
import 'func_sair.dart';
import 'func_review.dart';

actions(BuildContext context, {bool aponta = false, bool registro = false, GlobalKey? keyMenu,
    GlobalKey? key1, GlobalKey? key2,  GlobalKey? key3, GlobalKey? key4,  GlobalKey? key5}){
  return Padding(
    padding: const EdgeInsets.only(right: 5),
    child: PopupMenuButton<int>(
      key: keyMenu,
      child: Icon(Icons.more_vert),
      itemBuilder: (context) => [
        if(aponta && !registro)
          PopupMenuItem(
            key: key1,
            value: 1,
            child: Text("Apontamento"),
          ),
        if(!registro)
        PopupMenuItem(
          key: key2,
          value: 2,
          child: Text("Alterar Senha"),
        ),
        if(registro)
          PopupMenuItem(
            key: key1,
            value: 6,
            child: Text("Reenviar Marcações"),
          ),
        if(!registro)
        PopupMenuItem(
          key: key3,
          value: 3,
          child: Text("Configurações"),
        ),
        if(!Config.isWin && !registro)
          PopupMenuItem(
            key: key4,
            value: 4,
            child: Text("Avaliar App"),
          ),
        if(!registro)
        PopupMenuItem(
          key: key5,
          value: 5,
          child: Text("Sair"),
        ),
      ],
      //initialValue: intvalue,
      offset: Offset(10,5),
      onSelected: (value) async {
        switch( value ){
          case 1 :
            funcAponta(context);
            break;
          case 2 :
            //await AlterarSenhaModal(context);
            break;
          case 3 :
            funcConfig(context);
            break;
          case 4 :
            funcReview(context);
            break;
          case 5 :
            funcSair(context);
            break;
          case 6 :
            RegistroManger().enviarMarcacoesHistorico(context, UserPontoManager().usuario);
            break;
        }
      },
    )
  );
}