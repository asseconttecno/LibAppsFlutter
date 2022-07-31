import 'package:flutter/material.dart';

import '../../config.dart';
import '../http/http.dart';


class SenhaHoleriteService {
  final HttpCli _http = HttpCli();

  Future<String?> sendPass({String? email, String? cpf, }) async {
    String _metodo = '/holerite/email/senha';

    try{
      String? _cpf = cpf != null ? cpf.replaceAll('.', '').replaceAll('-', '') : null;
      Map<String, dynamic> body = {
        "Email": email,
        "Cpf": _cpf
      };
      print(body);
      print(Config.conf.apiHoleriteEmail! + _metodo);
      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: body
      );
      if(response.isSucess){
        return response.data['email'];
      }
      throw response.codigo.toString();
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case 404 :
          throw 'Email ou Cpf não cadastrado!';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }

  Future<bool?> alteracaoPass({required int id, required String senha, required String senhaNova,}) async {
    String _metodo = '/holerite/email/alterarSenha';
    MyHttpResponse? response;
    try{
      response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo, decoder: false,
          body: <String, dynamic>{
            "id": id,
            "senha": senha,
            "senhaNova": senhaNova
          }
      );
      if(response.isSucess){
        return response.isSucess;
      }
      throw response.codigo.toString();
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case 404 :
          throw response!.data;
        default :
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }
}