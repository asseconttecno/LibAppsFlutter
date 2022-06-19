import 'package:flutter/material.dart';

import '../../settintgs.dart';
import 'http/http.dart';


class UpdateAppService {
  HttpCli _http = HttpCli();

  Future<bool> postUpdateApp() async {
    String _api = "api/AppVersoes";

    final MyHttpResponse response = await _http.post(
        decoder: false,
        url: Settings.conf.apiEspelho! + _api,
        body: {
          "App": Settings.conf.nomeApp.toString(),
          "Versao": Settings.versao,
          "IsAndroid": !Settings.isIOS,
        }
    );

    try{
      if(response.isSucess){
        final dadosJson = response.data;
        return dadosJson;
      }
    }catch(e){
      debugPrint("postUpdateApp erro ${e.toString()}");
    }
    return false;
  }
}
