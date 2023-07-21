import 'package:flutter/material.dart';

import '../../config.dart';
import '../http/http.dart';

class SenhaPontoService {
  final HttpCli _http = HttpCli();


  Future<bool> sendPass(String email) async {
    String _api = "/api/funcionario/EsqueciMinhaSenha";
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAssepontoNova! + _api, decoder: false,
        body: {
          "DatabaseId": ,
          "Email": email.trim()
        }
    );
    if(response.isSucess){
      return true;
    }else{
      debugPrint(response.codigo.toString());
      throw 'Não foi possivel enviar sua senha, tente novamente!';
    }
  }

  Future<bool> alteracaoPass(String email, String atual, String nova, ) async {
    String _api = "/api/funcionario/AlterarSenha";
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAssepontoNova! + _api, decoder: false,
        body: {
          "DatabaseId": ,
          "Email": email.trim(),
          "NovaSenha": nova.trim()
        }
    );
    if(response.isSucess){
      return true;
    }else{
      debugPrint(response.codigo.toString());
      throw 'Não foi possivel alterar sua senha, tente novamente!';
    }
  }
}