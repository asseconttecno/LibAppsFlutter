import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class BancoHorasService {
  final HttpCli _http = HttpCli();

  Future<List<BancoDiasList>> getFuncionarioHistorico(UsuarioPonto? user) async {
    if(user != null){
      String _api = "/api/bancoHoras/GetFuncionarioBancoHoras";

      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAssepontoNova! + _api,
          body: {
            "User": {
              "UserId": user.funcionario?.funcionarioId.toString(),
              "Database": user.databaseId.toString()
            },
            "Periodo": {
              "DataInicial": DateFormat('yyyy-MM-dd').format(user.periodo!.dataInicial!),
              "DataFinal": DateFormat('yyyy-MM-dd').format(user.periodo!.dataFinal!)
            }
          }
      );

      try{
        if(response.isSucess){
          Map<String, dynamic> dadosJson = response.data;
          debugPrint(dadosJson.toString());
          final model = BancoHoras.fromMap(dadosJson);
          return model.bancoDiasList ?? [];
        }
      }catch(e){
        debugPrint("BancoHorasService getFuncionarioHistorico Erro Try ${e.toString()}");
      }
    }
    return [];
  }

}