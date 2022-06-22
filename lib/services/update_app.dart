import 'package:flutter/material.dart';

import '../../config.dart';
import 'http/http.dart';


class UpdateAppService {
  HttpCli _http = HttpCli();

  Future<bool> postUpdateApp() async {
    String _api = "api/AppVersoes";

    final MyHttpResponse response = await _http.post(
        decoder: false,
        url: Config.conf.apiEspelho! + _api,
        body: {
          "App": Config.conf.nomeApp.toString(),
          "Versao": Config.versao,
          "IsAndroid": !Config.isIOS,
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
