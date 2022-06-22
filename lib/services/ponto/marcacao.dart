import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class MarcacoesService  {
  HttpCli _http = HttpCli();


  Future<List<Marcacao>> getEspelho(UsuarioPonto? user) async {
    String _api = "api/apontamento/GetEspelho";

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
        var dadosJson = response.data;
        List<Marcacao> listaTemporaria = [];
        listaTemporaria = dadosJson['Apontamento'].map((e) => Marcacao.fromMap(e)).toList();
        return listaTemporaria;
      }
    }catch(e){
      debugPrint("Erro Try ${e.toString()}");
    }
    return [];
  }


}