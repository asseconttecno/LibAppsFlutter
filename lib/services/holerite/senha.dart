import 'package:flutter/material.dart';
import '../../config.dart';
import '../http/http.dart';


class SenhaHoleriteService {
  HttpCli _http = HttpCli();

  Future<String?> sendPass({String? email, String? cpf, }) async {
    String _metodo = '/holerite/email/senha';

    try{
      String? _cpf = cpf != null ? cpf.replaceAll('.', '').replaceAll('-', '') : null;
      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: <String, dynamic>{
            "Email": email,
            "Cpf": _cpf
          }
      );
      if(response.isSucess){
        return response.data['email'];
      }
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
      return response.isSucess;
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