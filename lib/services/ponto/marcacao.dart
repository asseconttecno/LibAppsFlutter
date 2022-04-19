import 'package:flutter/material.dart';

import '../../model/marcacao/marcacao.dart';
import '../../model/usuario/users.dart';
import '../../settintgs.dart';
import '../http/http_cliente.dart';
import '../http/http_response.dart';


class MarcacoesService  {
  HttpCli _http = HttpCli();


  Future<List<Marcacao>?> getEspelho(Usuario user) async {
    String _api = "api/apontamento/GetEspelho";

    final HttpResponse response = await _http.post(
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
        var dadosJson = response.data;
        List<Marcacao> listaTemporaria = [];
        listaTemporaria = dadosJson['Apontamento'].map((e) => Marcacao.fromMap(e)).toList();
        return listaTemporaria;
      }
    }catch(e){
      debugPrint("Erro Try ${e.toString()}");
    }
  }


}