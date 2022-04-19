import 'dart:io';
import 'enums/bio_support_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settings extends ChangeNotifier{
  Settings(){
    load();
  }
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final String apiFaceId = "https://assepontofacial.cognitiveservices.azure.com/face/v1.0/";
  static final String apiFaceIdKey = "99cdfd08672d4ba0aca3a494346e981a";

  static String apiHolerite = "https://www.asseweb.com.br/AssecontAPI/";
  static String apiUrl = "https://www.asseponto.com.br/asseponto.api.v5/";
  static String appStoreId = 'com.assecont.AssepontoMobile'; // ios '1490469231'
  static String versao = '2.1.5';
  static final bool isIOS = Platform.isIOS;
  static final bool isWin = Platform.isWindows;
  static String? senha;
  static bool primeiroAcesso = true;
  static Color corPribar = Color(0xff002450);
  static Color corPribar2 = Color(0xff27689e);
  static Color corPri = Color(0xffff8000);
  static bool isJailBroken = true;
  static bool canMockLocation = true;
  static bool isRealDevice = true;
  static BioSupportState bioState = BioSupportState.unknown;

  bool _darkTemas = false;
  bool get darkTemas => _darkTemas;
  set darkTemas(bool v){
    _darkTemas = v;
    memorizar();
    notifyListeners();
  }

  memorizar() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("darkTemas", _darkTemas.toString());
    }catch(e){
      debugPrint(e.toString());
    }
  }

  priacesso() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("priacesso", 'false');
    }catch(e){
      debugPrint(e.toString());
    }
  }

  load() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String? dark = prefs.getString("darkTemas");
      String acesso = (prefs.getString("priacesso") ?? 'true') ;
      primeiroAcesso =  acesso == 'true';
      darkTemas = dark == "true";
    }catch(e){
      debugPrint(e.toString());
    }

  }
}


//gabriel@assecont.com.br 1234



