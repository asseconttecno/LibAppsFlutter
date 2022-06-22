import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';

class MemorandosServices {
  HttpCli _http = HttpCli();

  Future<bool> postMemorando(UsuarioPonto usuario, DateTime data, String texto,
      int tipo ,{File? img, List<String>? marcacao}) async {
    String _api = "api/memorando/PostMemorando";
    Map<String,dynamic> body;
    if(tipo == 1){
      body = {
        "user": {
          "UserId": "${usuario.userId.toString()}",
          "Database": "${usuario.database.toString()}",
        },
        "data": "${data}",
        "tipo": tipo,
        "Texto": "$texto",
        "arquivonome": img != null ?
          "${usuario.userId}-${DateFormat('dd-MM-yyyy-hh-mm').format(DateTime.now())}.jpg" : null,
        "arquivo": img != null ? base64Encode(img.readAsBytesSync()) : null
      };
    }else { //if(tipo == 5)
      List<String?> temp = marcacao!.map((e) => e == '' ? null :
          "${DateFormat('dd/MM/yyyy').format(data)} ${e.toString()}").toList();
      debugPrint(temp.toString());
      body = {
        "user": {
          "UserId": "${usuario.userId.toString()}",
          "Database": "${usuario.database.toString()}",
        },
        "data": "${data}",
        "tipo": tipo,
        "Texto": "$texto",
        "marcacoes": temp
      };
    }

    if(body.isNotEmpty){
      try{
        final MyHttpResponse response = await _http.post(
            url: Config.conf.apiAsseponto! + _api,
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: body,
        );
        if(response.isSucess){
          Map dadosJson = response.data ;
          return dadosJson.containsKey("IsSuccess");
        }
      }catch(e){
        debugPrint("Erro Try ${e.toString()}");
      }
    }
    return false;
  }

  Future<List<Memorandos>> getMemorandos(UsuarioPonto? usuario, DateTime inicio, DateTime fim) async {
    String _api = "api/memorando/GetMemorandos";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseponto! + _api,
          body: {
            "User": {
              "UserId": usuario?.userId.toString(),
              "Database": usuario?.database.toString()
            },
            "Periodo": {
              "DataInicial": "${inicio}",
              "DataFinal": "${fim}"
            }
          }
      );
      if(response.isSucess){
        Map dadosJson = response.data ;
        if(dadosJson.containsKey("IsSuccess")){
          List<Memorandos> listaTemporaria;
          listaTemporaria = dadosJson["Result"]["Memorandos"].map((e) => Memorandos.fromMap(e)).toList();
          return listaTemporaria;
        }
      }else{
        debugPrint(response.codigo.toString());
      }
    }catch(e){
      debugPrint("Erro Try ${e.toString()}");
    }
    return [];
  }
}
