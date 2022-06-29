
import 'package:assecontservices/model/model.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../http/http.dart';

class SenhaPontoService {
  HttpCli _http = HttpCli();


  Future<bool> sendPass(String email) async {
    String _api = "/api/database/SendPass";
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAsseponto! + _api,
        body: {
          "Email": email.trim().replaceAll(' ', '')
        }
    );
    if(response.isSucess){
      var dadosJson = response.data;
      if(dadosJson["IsSuccess"]){
        print(dadosJson['Message']);
        return true;
      }else{
        throw dadosJson["Message"];
      }
    }else{
      debugPrint(response.codigo.toString());
      throw 'Não foi possivel enviar sua senha, tente novamente!';
    }
  }

  Future<bool> alteracaoPass(UsuarioPonto usuario, String atual, String nova, ) async {
    String _api = "/api/database/AlteracaoPass";
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAsseponto! + _api,
        body: {
          "Email": usuario.email.toString(),
          "SenhaAtual": atual.trim().replaceAll(' ', ''),
          "SenhaNova": nova.trim().replaceAll(' ', '')
        }
    );
    if(response.isSucess){
      var dadosJson = response.data;
      if(dadosJson["IsSuccess"]){
        return true;
      }else{
        throw dadosJson["Message"];
      }
    }else{
      debugPrint(response.codigo.toString());
      throw 'Não foi possivel alterar sua senha, tente novamente!';
    }
  }
}