import 'package:assecontservices/model/usuario/users.dart';
import 'package:flutter/material.dart';


import '../../model/apontamento/apontamento.dart';
import '../../settintgs.dart';
import 'http/http.dart';




class VersaoAppService {
  HttpCli _http = HttpCli();

  Future<List<Apontamento>?> getPeriodo(Usuario user) async {
    String _api = "api/apontamento/GetOutrosMeses";

    final MyHttpResponse response = await _http.post(
        url: Settings.apiHolerite + _api,

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
