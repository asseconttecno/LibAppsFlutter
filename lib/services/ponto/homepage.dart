import 'dart:async';
import 'package:flutter/material.dart';

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
              "UserId": user.userId.toString(),
              "Database": user.database.toString()
            },
            "Periodo": {
              "DataInicial": user.aponta?.datainicio,
              "DataFinal": user.aponta?.datatermino,
            }
          }
      );

      if(response.isSucess){
        var dadosJson = response.data;
        HomePontoModel homeModel = HomePontoModel.fromMap(dadosJson);
        return homeModel;
      }
    } catch(e){
      debugPrint("Home erro ${e.toString()}");
    }
  }
}