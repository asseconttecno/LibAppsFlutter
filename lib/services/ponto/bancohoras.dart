import 'package:flutter/material.dart';

import '../../model/banco_horas/banco_horas.dart';
import '../../model/usuario/users.dart';
import '../../settintgs.dart';
import '../http/http.dart';


class BancoHorasService {
  HttpCli _http = HttpCli();

  Future<List<BancoHoras>?> getFuncionarioHistorico(Usuario user) async {
    String _api = "api/bcohoras/GetFuncionarioHistorico";

    final MyHttpResponse response = await _http.post(
        url: Settings.apiUrl + _api,
        body: {
          "User": {
            "UserId": user.userId.toString(),
            "Database": user.database.toString()
          },
          "Periodo": {
            "DataInicial": user.aponta?.datainicio,
            "DataFinal": user.aponta?.datatermino
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
  }

}