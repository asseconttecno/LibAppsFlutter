import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class BancoHorasService {
  HttpCli _http = HttpCli();

  Future<List<BancoHoras>> getFuncionarioHistorico(UsuarioPonto? user) async {
    String _api = "/api/bcohoras/GetFuncionarioHistorico";

    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAsseponto! + _api,
        body: {
          "User": {
            "UserId": user?.userId.toString(),
            "Database": user?.database.toString()
          },
          "Periodo": {
            "DataInicial": user?.aponta?.datainicio,
            "DataFinal": user?.aponta?.datatermino
          }
        }
    );

    try{
      if(response.isSucess){
        Map dadosJson = response.data;
        if(dadosJson['IsSuccess'] && dadosJson.containsValue("Result")
                && dadosJson["Result"]['BancoDiaList'].length > 0){

          List<BancoHoras> listaTemporaria = [];
          listaTemporaria = dadosJson["Result"]['BancoDiaList'].map((e) => BancoHoras.fromMap(e)).toList();
          return listaTemporaria;
        }
      }
    }catch(e){
      debugPrint("Erro Try getFuncionarioHistorico ${e.toString()}");
    }
    return [];
  }

}