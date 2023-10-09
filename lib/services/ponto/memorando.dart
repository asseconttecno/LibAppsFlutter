import 'dart:convert';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';

class MemorandosServices {
  final HttpCli _http = HttpCli();

  Future<bool> postMemorando(UsuarioPonto usuario, DateTime data, String texto,
      int tipo ,{File? img, List<String>? marcacao}) async {
    String _api = "/api/memorando/PostMemorando";
    Map<String,dynamic> body;
    if(tipo == 1){
      body = {
        "user": {
          "UserId": usuario.funcionario?.funcionarioId.toString(),
          "Database": usuario.databaseId.toString()
        },
        "data": "${data}",
        "tipo": tipo,
        "Texto": "$texto",
        "arquivonome": img != null ?
          "${usuario.funcionario?.funcionarioId}-${DateFormat('dd-MM-yyyy-hh-mm').format(DateTime.now())}.jpg" : null,
        "arquivo": img != null ? base64Encode(img.readAsBytesSync()) : null
      };
    }else { //if(tipo == 5)
      List<String?> temp = marcacao?.map((e) => e == '' ? null :
          "${DateFormat('dd/MM/yyyy').format(data)} ${e.toString()}").toList() ?? [];
      body = {
        "user": {
          "UserId": usuario.funcionario?.funcionarioId.toString(),
          "Database": usuario.databaseId.toString()
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
            body: body,
        );
        if(response.isSucess){
          Map dadosJson = response.data ;
          return dadosJson.containsKey("IsSuccess");
        }
      }catch(e){
        debugPrint("MemorandosServices postMemorando Erro Try ${e.toString()}");
      }
    }
    return false;
  }

  Future<List<Memorandos>> getMemorandos(UsuarioPonto? usuario, DateTime inicio, DateTime fim) async {
    String _api = "/api/memorando/GetMemorandos";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseponto! + _api,
          body: {
            "User": {
              "UserId": usuario?.funcionario?.funcionarioId.toString(),
              "Database": usuario?.databaseId.toString()
            },
            "Periodo": {
              "DataInicial": DateFormat('yyyy-MM-dd').format(inicio),
              "DataFinal": DateFormat('yyyy-MM-dd').format(fim)
            }
          }
      );
      if(response.isSucess){
        Map dadosJson = response.data ;
        if(dadosJson.containsKey("IsSuccess")){
          List temp = dadosJson["Result"]["Memorandos"];
          if(temp.isNotEmpty){
            List<Memorandos> listaTemporaria;
            listaTemporaria = temp.map((e) => Memorandos.fromMap(e)).toList();
            return listaTemporaria;
          }
        }
      }else{
        debugPrint(response.codigo.toString());
      }
    }catch(e){
      debugPrint("MemorandosServices getMemorandos Erro Try ${e.toString()}");
    }
    return [];
  }
}
