import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';


import '../../controllers/controllers.dart';
import '../../config.dart';
import '../../common/common.dart';
import '../../enums/enums.dart';
import 'func_aponta.dart';
import 'func_config.dart';
import 'func_sair.dart';
import 'func_review.dart';


actions(BuildContext context, {bool aponta = false, bool registro = false,
  bool config = false, Function()? onAlter, GlobalKey? keyMenu, GlobalKey? key1,
  GlobalKey? key2,  GlobalKey? key3, GlobalKey? key4,  GlobalKey? key5}){
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
        if(!config)
          PopupMenuItem(
            key: key3 ,
            value: 3,
            child: CustomText.text("Configurações"),
          ),
        if(!kIsWeb && !Config.isWin && !registro)
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
              alterUser(context, onAlter);
            } else if(Config.conf.nomeApp == VersaoApp.AssewebApp) {
              alterEmpresa(context, onAlter);
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
      child: Icon(Icons.more_vert, color: !context.watch<Config>().darkTemas && aponta && kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone
          ? Colors.black : Colors.white,),
    )
  );
}