import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';

class UserHoleriteService {
  HttpCli _http = HttpCli();


  Future<List<UsuarioHolerite>?> signInAuth({required String email, required String senha}) async {
    String _metodo = '/login';
    try{
      String _email = CPFValidator.isValid(email) ?
        email.replaceAll('.', '').replaceAll('-', '').replaceAll('/', '') : email;

      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: <String, dynamic>{
            "Email": _email,
            "Senha": senha
          }
      );

      if (response.isSucess) {
        final List<UsuarioHolerite> _user = response.data.map((e) => UsuarioHolerite.fromMap(e)).toList();
        return _user;
      }else{
        throw 404;
      }
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case 404 :
          throw 'Usuário ou senha inválidos!';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }
}