import 'dart:convert';
import '../../helper/conn.dart';
import '../../services/ponto/users.dart';
import '../../settintgs.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class SenhaManager extends ChangeNotifier {
  ConnectionStatusSingleton _connectionStatus = ConnectionStatusSingleton.getInstance();


  sendPass(String email, {required Function onFail, required Function onSuccess}) async {
    String _api = "api/database/SendPass";
    try{
      if(await _connectionStatus.checkConnection()){
        final http.Response response = await http.post(Uri.parse(Settings.apiUrl + _api),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              "Email": email.trim().replaceAll(' ', '')
            })
        );
        if(response.statusCode == 200 && response.body != null
            && response.body != 'null' && response.body != ''){
          var dadosJson = json.decode( response.body );
          if(dadosJson["IsSuccess"]){
            onSuccess(dadosJson['Message']);
          }else{
            onFail(dadosJson["Message"]);
          }
        }else{
          debugPrint(response.statusCode.toString());
          onFail('Não foi possivel enviar sua senha, tente novamente!');
        }
      }else{
        onFail('Sem conexão com internet!');
      }
    }catch(e){
      debugPrint("sendPass erro ${e.toString()}");
      onFail('Não foi possivel enviar sua senha, tente novamente!');
    }
  }

  alteracaoPass(String atual, String nova, {required Function onFail, required Function onSuccess}) async {
    String _api = "api/database/AlteracaoPass";
    try{
      final http.Response response = await http.post(Uri.parse(Settings.apiUrl  + _api),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            "Email": "${UserManager().usuario?.email.toString()}",
            "SenhaAtual": atual.trim().replaceAll(' ', ''),
            "SenhaNova": nova.trim().replaceAll(' ', '')
          })
      );
      if(response.statusCode == 200 && response.body != null
          && response.body != 'null' && response.body != ''){
        var dadosJson = json.decode( response.body );
        if(dadosJson["IsSuccess"]){
          onSuccess();
        }else{
          onFail(dadosJson["Message"]);
        }
      }else{
        debugPrint(response.statusCode.toString());
        onFail('Não foi possivel alterar sua senha, tente novamente!');
      }
    }catch(e){
      debugPrint("alteracaoPass erro ${e.toString()}");
      onFail('Não foi possivel alterar sua senha, tente novamente!');
    }
  }
}