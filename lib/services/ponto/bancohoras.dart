import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class BancoHorasService {
  final HttpCli _http = HttpCli();

  Future<List<BancoHoras>> getFuncionarioHistorico(UsuarioPonto? user) async {
    if(user != null){
      String _api = "/api/bcohoras/GetFuncionarioHistorico";

      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseponto! + _api,
          body: {
            "User": {
              "UserId": user.userId.toString(),
              "Database": user.database.toString()
            },
            "Periodo": {
              "DataInicial": DateFormat('yyyy-MM-dd').format(user.aponta!.datainicio),
              "DataFinal": DateFormat('yyyy-MM-dd').format(user.aponta!.datatermino)
            }
          }
      );

      try{
        if(response.isSucess){
          Map dadosJson = response.data;
          if(dadosJson['IsSuccess'] && dadosJson.containsValue("Result")
              && dadosJson["Result"]['BancoDiaList'].length > 0){
            List temp = dadosJson["Result"]['BancoDiaList'];
            if(temp.isNotEmpty){
              List<BancoHoras> listaTemporaria = [];
              listaTemporaria = temp.map((e) => BancoHoras.fromMap(e)).toList();
              return listaTemporaria;
            }
          }
        }
      }catch(e){
        debugPrint("BancoHorasService getFuncionarioHistorico Erro Try ${e.toString()}");
      }
    }
    return [];
  }

}