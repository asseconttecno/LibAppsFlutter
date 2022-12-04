import 'package:flutter/material.dart';

import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import 'common.dart';


class CustomAlert {

  static sucess({required BuildContext context, required String mensage}){
    return SuccessAlertBox(
        context: context,
        title: 'Sucesso!',
        messageText: mensage + '\n',
        buttonText: 'OK'
    );
  }

  static info({required BuildContext context, required String mensage}){
    return InfoAlertBox(
        context: context,
        title: 'Atenção!',
        infoMessage: mensage + '\n',
        buttonText: 'OK'
    );
  }

  static erro({required BuildContext context, required String mensage}){
    return WarningAlertBox(
        context: context,
        title: 'Falha!',
        messageText: mensage + '\n',
        buttonText: 'OK'
    );
  }

  static custom({
    required BuildContext context,
    required Widget corpo,
    String? titulo,
    Widget? widgeTitulo,
    String? txtBotaoSucess,
    String? txtBotaoCancel,
    VoidCallback? funcSucess,
    VoidCallback? funcCancel}){

    bool isDark = context.read<Config>().darkTemas;
    return showDialog(
        context: context,
        builder: (context){
          return  AlertDialog(
            titlePadding:  EdgeInsets.all(5),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.clear, color: isDark ? Colors.white60 : Colors.black54,)
                  ),
                ),
                widgeTitulo != null ? widgeTitulo :
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomText.text(titulo?.toUpperCase() ?? '', style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
              ],
            ),
            content: corpo,
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            buttonPadding: EdgeInsets.zero,
            actions: [
              if(txtBotaoCancel != null)
                TextButton(
                    onPressed: (){
                      funcCancel!();
                      Navigator.pop(context);
                    },
                    child: Container(
                      //width: 100, alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: CustomText.text(txtBotaoCancel, style: TextStyle(color: isDark ? Colors.white54 : Colors.black45),))
                ),
              if(txtBotaoCancel != null) SizedBox(width: 10,),
              if(txtBotaoSucess != null)
                TextButton(
                    onPressed: (){
                      funcSucess!();
                      Navigator.pop(context);
                    },
                    child: Container(
                      //width: 100, alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: CustomText.text(txtBotaoSucess, style: TextStyle(color: Colors.blue),))
                ),
              SizedBox(width: 10,),
            ],
          );
        }
    );
  }


}