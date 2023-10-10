import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';

class CameraPontoService {
  final HttpCli _http = HttpCli();

  Future<bool> setPhoto(UsuarioPonto user, List<int> img, String? faceId) async {
    String _api = "/api/funcionario/AlterarFoto";
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAssepontoNova! + _api, decoder: false,
        body: {
          "user":{
            "UserId": user.funcionario?.funcionarioId.toString(),
            "Database": user.databaseId.toString(),
            "Array": img
          },
        }
    );
    return response.isSucess;
  }

/*  addface(Uint8List face, String personId, {required Function sucesso, required Function erro}) async {
    String api = "largepersongroups/assecont/persons/$personId/persistedfaces";
    try{
      final http.Response response = await http.post(
          Uri.parse(Config.apiFaceId+api),
          headers: <String, String>{
            'Content-Type': 'application/octet-stream',
            "Ocp-Apim-Subscription-Key" : Config.apiFaceIdKey
          },
          body: face
      ).catchError((onError){
        debugPrint(onError.toString());
      });
      if(response.statusCode == 200){
        var dadosJson = json.decode( response.body );
        if(dadosJson != null && dadosJson.length > 0){
          Map result = dadosJson ;
          if(result != null && result["persistedFaceId"] != null){
            sucesso();
          }else{
            debugPrint(result.toString());
            erro("Não foi possivel cadastrar seu rosto");
          }
        }else{
          debugPrint(response.body);
          erro("Não foi possivel reconhecer seu rosto");
        }
      }else{
        debugPrint(response.body) ;
        debugPrint("Erro statusCode detect ${response.statusCode}");
        erro('Falha ao reconhecer seu rosto, tente novamente!');
      }
    }catch(e){
      debugPrint("Erro Try detect ${e.toString()}");
      erro('Falha ao se conectar, verifique sua conexão com internet');
    }
  }

  deleteface(String personId, {required Function sucesso, required Function erro}) async {
    String api = "largepersongroups/assecont/persons/$personId";
    try{
      final http.Response response = await http.delete(Uri.parse(Config.apiFaceId+api),
          headers: <String, String>{
            "Ocp-Apim-Subscription-Key" : Config.apiFaceIdKey
          },
      ).catchError((onError){
        debugPrint(onError.toString());
      });
      if(response.statusCode == 200){
        sucesso();
      }else{
        debugPrint(response.body) ;
        debugPrint("Erro statusCode detect ${response.statusCode}");
        erro('Falha ao reconhecer seu rosto, tente novamente!');
      }
    }catch(e){
      debugPrint("Erro Try detect ${e.toString()}");
      erro('Falha ao se conectar, verifique sua conexão com internet');
    }
  }

  addperson(String nome, {required Function sucesso, required Function erro}) async {
    String api = "largepersongroups/assecont/persons";
    try{
      final http.Response response = await http.post(Uri.parse(Config.apiFaceId+api),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Ocp-Apim-Subscription-Key" : Config.apiFaceIdKey
          },
          body: jsonEncode(<String, dynamic>{
            "name": nome,
          })
      ).catchError((onError){
        debugPrint(onError.toString());
      });
      if(response.statusCode == 200){
        var dadosJson = json.decode( response.body );
        if(dadosJson != null && dadosJson.length > 0){
          Map result = dadosJson ;
          if(result != null && result["personId"] != null){
            sucesso(result["personId"]);
          }else{
            debugPrint(response.body);
            erro("Não foi possivel cadastrar seu rosto");
          }
        }else{
          debugPrint(response.body);
          erro("Não foi possivel reconhecer seu rosto");
        }
      }else{
        debugPrint(response.body) ;
        debugPrint("Erro statusCode detect ${response.statusCode}");
        erro('Falha ao reconhecer seu rosto, tente novamente!');
      }
    }catch(e){
      debugPrint("Erro Try detect ${e.toString()}");
      erro('Falha ao se conectar, verifique sua conexão com internet');
    }
  }*/


}