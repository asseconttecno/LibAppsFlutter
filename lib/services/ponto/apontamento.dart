import 'package:flutter/material.dart';


import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';



class ApontamentoService {
  final HttpCli _http = HttpCli();

  Future<List<Apontamento>> getPeriodo(UsuarioPonto? user) async {
    String _api = "/api/apontamento/GetOutrosMeses";

    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAsseponto! + _api,
        body: {
          "User": {
            "UserId": user?.userId.toString(),
            "Database": user?.database.toString()
          }
        }
    );

    try{
      if(response.isSucess){
        Map dadosJson = response.data;
        if(dadosJson.containsKey("Apontamentos") && dadosJson["Apontamentos"].length > 0){
          List temp = dadosJson["Apontamentos"];
          if(temp.isNotEmpty){
            List<Apontamento> listaTemporaria = temp.map((e) => Apontamento.fromMap(e)).toList();
            listaTemporaria.sort((a,b) => a.datainicio.compareTo(b.datainicio));
            return listaTemporaria;
          }
        }
      }
    }catch(e){
      debugPrint("ApontamentoService getPeriodo erro ${e.toString()}");
    }
    return [Apontamento.padrao()];
  }
}
