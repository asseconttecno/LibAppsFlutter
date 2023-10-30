import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../config.dart';
import '../../common/common.dart';
import '../../enums/enums.dart';
import 'func_alter_empresa.dart';
import 'func_alter_user.dart';
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
      itemBuilder: (context) => [
        if(Config.conf.nomeApp == VersaoApp.HoleriteApp && aponta)
          PopupMenuItem(
            key: key1,
            value: 0,
            child: CustomText.text("Alterar Usuario"),
          ),
        if(Config.conf.nomeApp == VersaoApp.AssewebApp && aponta)
          PopupMenuItem(
            key: key1,
            value: 0,
            child: CustomText.text("Alterar Empresa"),
          ),
        if(Config.conf.nomeApp == VersaoApp.PontoApp && aponta && !registro)
          PopupMenuItem(
            key: key1,
            value: 1,
            child: CustomText.text("Apontamento"),
          ),
        if(Config.conf.nomeApp != VersaoApp.PontoApp || !registro)
        PopupMenuItem(
          key: key2,
          value: 2,
          child: CustomText.text("Alterar Senha"),
        ),
        if(Config.conf.nomeApp == VersaoApp.PontoApp && registro)
          PopupMenuItem(
            key: key1,
            value: 6,
            child: CustomText.text("Reenviar Marcações"),
          ),
        if(!registro)
        PopupMenuItem(
          key: key3 ,
          value: 3,
          child: CustomText.text("Configurações"),
        ),
        if(!Config.isWin && !registro)
          PopupMenuItem(
            key:  key4  ,
            value: 4,
            child: CustomText.text("Avaliar App"),
          ),
        if(!registro)
        PopupMenuItem(
          key:  key5 ,
          value: 5,
          child: CustomText.text("Sair"),
        ),

      ],
      //initialValue: intvalue,
      offset: const Offset(10,5),
      onSelected: (value) async {
        switch( value ){
          case 0 :
            if(Config.conf.nomeApp == VersaoApp.HoleriteApp) {
              alterUser(context);
            } else if(Config.conf.nomeApp == VersaoApp.AssewebApp) {
              alterEmpresa(context);
            }
            break;
          case 1 :
            funcAponta(context);
            break;
          case 2 :
            await AlterarSenhaModal(context);
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
      child: Icon(Icons.more_vert, color: !context.watch<Config>().darkTemas && aponta && kIsWeb
          ? Colors.black : Colors.white,),
    )
  );
}