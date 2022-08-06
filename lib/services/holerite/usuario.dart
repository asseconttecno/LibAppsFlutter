import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';

class UserHoleriteService {
  final HttpCli _http = HttpCli();


  Future<List<UsuarioHolerite>?> signInAuth({required String email, required String senha}) async {
    String _metodo = '/holerite/login';
    try{
      String _email = CPFValidator.isValid(email) ?
        email.replaceAll('.', '').replaceAll('-', '').replaceAll('/', '') : email;

      print(Config.conf.apiHoleriteEmail! + _metodo);

      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: <String, dynamic>{
            "Email": _email,
            "Senha": senha
          }
      );

      if (response.isSucess) {
        List user = response.data;
        final List<UsuarioHolerite> _user = user.map((e) => UsuarioHolerite.fromMap(e)).toList();
        return _user;
      }else{
        throw response.codigo.toString();
      }
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case "404" :
          throw 'Usuário ou senha inválidos!';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }
}