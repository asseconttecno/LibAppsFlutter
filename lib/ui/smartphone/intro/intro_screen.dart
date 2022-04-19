import 'dart:async';
import 'dart:io';
import '../../../helper/conn.dart';
import '../../../settintgs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:forceupdate/forceupdate.dart';
import 'package:safe_device/safe_device.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  ConnectionStatusSingleton _connectionStatus = ConnectionStatusSingleton.getInstance();


  @override
  void initState() {
    super.initState();
     checkVersion();
  }

  checkVersion() async {
    try{
      if(Settings.isWin) throw 'executando no windowns';
      final checkVersion = CheckVersion(context: context,
          androidId: 'com.assecont.AssepontoMobile',
          iOSId: 'com.assecont.assepontoweb'
      );
      if(Settings.isJailBroken && Settings.isRealDevice){
        bool check = await _connectionStatus.checkConnection();
        if(check){
          final appStatus = await checkVersion.getVersionStatus().timeout(
              Duration(seconds: 3), onTimeout: () {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }).catchError((onError){
            debugPrint(onError.toString());
            Future.delayed(
                Duration(seconds: 3),
                    () {
                  if (this.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  }
                }
            );
          });
          debugPrint(appStatus?.appStoreUrl);
          debugPrint(appStatus?.localVersion);
          debugPrint(appStatus?.storeVersion);
          debugPrint(appStatus?.canUpdate?.toString());

          if (appStatus?.canUpdate ?? false) {
            await checkVersion.showUpdateDialog(
              "com.assecont.AssepontoMobile", "1490469231",
              versionStatus: appStatus,
              titleText: 'Exite uma nova versão',
              message: '\nClique em update para atualizar!\n',
              updateText: 'Update',
              dismissText: 'Continuar',
              dismissFunc: (){
                Navigator.pop(context);
                Future.delayed(
                    Duration(seconds: 2),
                        () {
                      if (this.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      }
                    }
                );
              }
            );
          }
          Future.delayed(
              Duration(seconds: 2),
                  () {
                if (this.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }
              }
          );
        }else{
          Future.delayed(
              Duration(seconds: 3),
                  () {
                if (this.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }
              }
          );
        }
      }else{
        await DangerAlertBox(
            context: context,
            title: 'Desculpe',
            messageText: 'Não é possivel executar este app neste dispositivo!',
            buttonText: 'ok'
        );
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
    } on TimeoutException {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }catch(e){
      Future.delayed(
          Duration(seconds: 2),
              (){
            if (this.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            }
          }
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Settings.corPribar2,   Settings.corPribar]
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: Image.asset('assets/imagens/LOGO_ASSECONT.png', fit: BoxFit.fitWidth,),
          ),
          Container(
            width: 50,
              child: LinearProgressIndicator(minHeight: 10, backgroundColor: Colors.transparent,)
          )
        ],
      ),
    );
  }
}
