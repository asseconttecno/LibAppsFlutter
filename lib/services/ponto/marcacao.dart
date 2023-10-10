import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class MarcacoesService  {
  final HttpCli _http = HttpCli();


  Future<List<Marcacao>> getEspelho(UsuarioPonto? user) async {
    if(user != null){
      String _api = "/api/apontamento/Marcacoes";
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
          var dadosJson = response.data;
          List temp = dadosJson['Apontamento'];
          if(temp.isNotEmpty){
            List<Marcacao> listaTemporaria = [];
            listaTemporaria = temp.map((e) => Marcacao.fromMap(e)).toList();
            return listaTemporaria;
          }
        }
      }catch(e){
        debugPrint("MarcacoesService getEspelho Erro Try ${e.toString()}");
      }
    }
    return [];
  }


}