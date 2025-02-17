import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_device/safe_device.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:external_path/external_path.dart';
import 'package:universal_io/io.dart';

import 'enums/enums.dart';
import 'model/model.dart';


class Config extends ChangeNotifier {
  Config() {_init();}

  static ConfiguracoesModel conf = const ConfiguracoesModel();

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static final bool isIOS = Platform.isIOS;
  static final bool isWin = Platform.isWindows;

  static const Color corPribar =  Color(0xff002450);
  static const Color corPribar2 =  Color(0xff27689e);
  static const Color corPri =  Color(0xffff8000);

  static BioSupportState bioState = BioSupportState.unknown;

  static bool isReenvioMarc = false;
  static bool primeiroAcesso = true;
  static bool isJailBroken = false;
  static bool canMockLocation = false;
  static bool isRealDevice = true;

  static String versao = '99.0.0';
  static String documentos = '';
  static String? usenha;

  bool _darkTemas = false;
  bool get darkTemas => _darkTemas;
  set darkTemas(bool v){
    _darkTemas = v;
    _memorizar();
    notifyListeners();
  }


  priacesso() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("priacesso", false);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  _memorizar() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("darkTemas", _darkTemas);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  _init() async {
    try{
      final packageInfo = await PackageInfo.fromPlatform();
      versao = packageInfo.version;

      final prefs = await SharedPreferences.getInstance();
      primeiroAcesso =  prefs.getBool("priacesso") ?? true;
      darkTemas = prefs.getBool("darkTemas") ?? false;
      if(Platform.isAndroid){
        documentos =  await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);
        if(documentos == ''){
          documentos =  await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
        }
      }


      if(!kIsWeb){
        if(!Config.isWin){
          isRealDevice = await SafeDevice.isRealDevice;
          canMockLocation = await SafeDevice.canMockLocation;
        }

        /*if(Config.isIOS) {
          Config.isJailBroken = await SafeDevice.isJailBroken;
        }*/
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }
}


//gabriel@assecont.com.br 1234



