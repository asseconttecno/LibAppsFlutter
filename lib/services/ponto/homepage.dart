import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class HomePontoService {
  final HttpCli _http = HttpCli();


  Future<HomePontoModel?> getHome(UsuarioPonto user) async {
    String _api = "/api/apontamento/GetHome";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseponto! + _api,
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

      if(response.isSucess){
        Map dadosJson = response.data;
        HomePontoModel homeModel = HomePontoModel.fromMap(dadosJson);
        return homeModel;
      }
    } catch(e){
      debugPrint("HomePontoService getHome erro ${e.toString()}");
    }
  }
}