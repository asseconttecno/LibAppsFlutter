import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/tablet/empresa_manager.dart';
import '../../model/model.dart';
import '../../config.dart';
import '../../model/ponto/apontamento/apontamento_dia.dart';
import '../http/http.dart';


class MarcacoesService  {
  final HttpCli _http = HttpCli();


  Future<ApontamentoDiaModel?> getEspelho(UsuarioPonto? user, DateTime data) async {
    if(user != null){
      String _api = "/api/apontamento/dia";
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAssepontoNova! + _api,
          body: {
            "User": {
              "UserId": user.funcionario?.funcionarioId.toString(),
              "Database": user.databaseId?.toString() ?? EmpresaPontoManager.empresa?.database,
            },
            "Periodo": {
              "DataInicial": DateFormat('yyyy-MM-dd').format(data),
            }
          }
      );

      print(response.data);
      try{
        if(response.isSucess){
          var dadosJson = response.data;
          final model = ApontamentoDiaModel.fromMap(dadosJson);
          return model;
        }
      }catch(e){
        debugPrint("MarcacoesService getEspelho Erro Try ${e.toString()}");
      }
    }
  }


}