import 'dart:io';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:external_path/external_path.dart';

import 'enums/enums.dart';
import 'model/model.dart';


class Config extends ChangeNotifier {
  Config() {_init();}

  static ConfiguracoesModel conf = ConfiguracoesModel();

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static final bool isIOS = Platform.isIOS;
  static final bool isWin = Platform.isWindows;

  static Color corPribar = const Color(0xff002450);
  static Color corPribar2 = const Color(0xff27689e);
  static Color corPri = const Color(0xffff8000);

  static BioSupportState bioState = BioSupportState.unknown;

  static bool primeiroAcesso = true;
  static bool isJailBroken = true;
  static bool canMockLocation = true;
  static bool isRealDevice = true;

  static String versao = '0.0.0';
  static String documentos = '';
  static String? senha;

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
      final prefs = await SharedPreferences.getInstance();
      final packageInfo = await PackageInfo.fromPlatform();
      primeiroAcesso =  prefs.getBool("priacesso") ?? true;
      darkTemas = prefs.getBool("darkTemas") ?? false;
      versao = packageInfo.version;
      documentos =  await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);
      if(documentos == ''){
        documentos =  await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }


}


//gabriel@assecont.com.br 1234



