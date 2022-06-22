import 'dart:async';
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class HomeService {
  HttpCli _http = HttpCli();


  Future<HomeModel?> getHome(UsuarioPonto user) async {
    String _api = "api/apontamento/GetHome";
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
        HomeModel homeModel = HomeModel.fromMap(dadosJson);
        return homeModel;
      }
    } catch(e){
      debugPrint("Home erro ${e.toString()}");
    }
  }
}