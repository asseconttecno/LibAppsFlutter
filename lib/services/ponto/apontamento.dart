import 'package:assecontservices/model/usuario/users.dart';
import 'package:flutter/material.dart';


import '../../model/apontamento/apontamento.dart';
import '../../settintgs.dart';
import '../http/http_cliente.dart';
import '../http/http_response.dart';



class ApontamentoService {
  HttpCli _http = HttpCli();

  Future<List<Apontamento>?> getPeriodo(Usuario user) async {
    String _api = "api/apontamento/GetOutrosMeses";

    final HttpResponse response = await _http.post(
        url: Settings.apiUrl + _api,

        body: {
          "User": {
            "UserId": user.userId.toString(),
            "Database": user.database.toString()
          }
        }
    );

    try{
      if(response.isSucess){
        var dadosJson = response.data;
        if(dadosJson["Apontamentos"].length > 0){
          List<Apontamento> listaTemporaria = [];
          listaTemporaria = dadosJson["Apontamentos"].map((e) => Apontamento.fromMap(e)).toList();
          return listaTemporaria;
        }
      }
    }catch(e){
      debugPrint("aponta erro ${e.toString()}");
    }
  }
}
