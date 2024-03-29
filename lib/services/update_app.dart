import 'package:flutter/material.dart';

import '../../config.dart';
import 'http/http.dart';


class UpdateAppService {
  final HttpCli _http = HttpCli();

  Future<bool> postUpdateApp() async {
    String _api = "/api/Versoes";

    Map<String, dynamic> bod = {
      "App": Config.conf.nomeApp.toString().replaceAll('VersaoApp.', ''),
      "Versao": Config.versao,
      "IsAndroid": !Config.isIOS,
    };

    debugPrint(bod.toString());
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiEspelho! + _api,
        body: bod
    );

    try{
      if(response.isSucess){
        final dadosJson = response.data;
        Config.isReenvioMarc = dadosJson['isReenviar'];
        return dadosJson['isUpdate'];
      }
    }catch(e){
      debugPrint("postUpdateApp erro ${e.toString()}");
    }
    return false;
  }
}
