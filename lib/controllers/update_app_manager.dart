import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:launch_review/launch_review.dart';
import 'package:store_launcher/store_launcher.dart';

import '../common/common.dart';
import '../services/services.dart';
import '../settintgs.dart';


class UpdateAppManager {
  UpdateAppService _service = UpdateAppService();

  checkVersion(BuildContext context) async {
    try{
      if(Settings.isWin) throw 'executando no windowns';

      if(kReleaseMode && ((Settings.isIOS && Settings.isJailBroken) || (!Settings.isIOS && !Settings.isRealDevice))){
        CustomAlert.custom(
            context: context,
            titulo: 'Atenção!',
            corpo: Text('Não é possivel executar este app neste dispositivo!',
              maxLines: 2, softWrap: true, textAlign: TextAlign.center,),
            txtBotaoSucess: 'OK',
            funcSucess: _funcExit()
        );
      }else{
          final bool appStatus = await _service.postUpdateApp();

          if(appStatus) {
            await CustomAlert.custom(
                context: context,
                titulo: 'Exite uma nova versão',
                corpo: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('\nAtualize agora mesmo para poder continuar acessando o app!\n',
                    textAlign: TextAlign.center,),
                ),
                txtBotaoSucess: 'Atualizar',
                txtBotaoCancel: 'Fechar',
                funcCancel: _funcExit(),
                funcSucess: () {
                  Settings.isIOS ? StoreLauncher.openWithStore(Settings.conf.iosAppId).catchError((e) {
                    print('ERROR> $e');
                    LaunchReview.launch(
                      androidAppId: Settings.conf.androidAppId,
                      iOSAppId: Settings.conf.iosAppId,
                    );
                  }) :
                  LaunchReview.launch(
                    androidAppId: Settings.conf.androidAppId,
                    iOSAppId: Settings.conf.iosAppId,
                  );
                }
            );
          }else{
            Future.delayed(Duration(seconds: 2), (){
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            });
          }
      }
    } catch(e){
      print(e);
      Future.delayed(Duration(seconds: 2), (){
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
    }
  }


  _funcExit(){
    if (Settings.isIOS) {
      try {
        exit(0);
      } catch (e) {
        SystemNavigator.pop(); // for IOS, not true this, you can make comment this :)
      }
    } else {
      try {
        SystemNavigator.pop(); // sometimes it cant exit app
      } catch (e) {
        exit(0); // so i am giving crash to app ... sad :(
      }
    }
  }
}