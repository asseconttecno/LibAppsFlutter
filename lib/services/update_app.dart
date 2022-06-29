import 'package:flutter/material.dart';

import '../../config.dart';
import 'http/http.dart';


class UpdateAppService {
  HttpCli _http = HttpCli();

  Future<bool> postUpdateApp() async {
    String _api = "/api/AppVersoes";

    Map<String, dynamic> bod = {
      "App": Config.conf.nomeApp.toString().replaceAll('VersaoApp.', ''),
      "Versao": Config.versao,
      "IsAndroid": !Config.isIOS,
    };
    final MyHttpResponse response = await _http.post(
        decoder: false,
        url: Config.conf.apiEspelho! + _api,
        body: bod
    );

    try{
      if(response.isSucess){
        final dadosJson = response.data;
        return dadosJson.toString() == 'true';
      }
    }catch(e){
      debugPrint("postUpdateApp erro ${e.toString()}");
    }
    return false;
  }
}
