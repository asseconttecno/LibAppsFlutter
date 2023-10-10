import 'package:flutter/material.dart';


import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';



class ApontamentoService {
  final HttpCli _http = HttpCli();

  Future<List<Apontamento>> getPeriodo(UsuarioPonto? user) async {
    String _api = "/api/apontamento/MesesApontamentos";

    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAssepontoNova! + _api,
        body: {
          "User": {
            "UserId": user?.funcionario?.funcionarioId.toString(),
            "Database": user?.databaseId.toString()
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
            listaTemporaria = listaTemporaria.toSet().toList();
            listaTemporaria.sort((a,b) => b.datainicio.compareTo(a.datainicio));
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
