import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../../utils/validacoes.dart';
import '../http/http.dart';

class UserHoleriteService {
  final HttpCli _http = HttpCli();


  Future<UsuarioHoleriteModel?> signInAuth({required String email, required String senha, String? token}) async {
    String _metodo = '/auth/local';
    try{
      String _email = CPFValidator.isValid(email) ? Validacoes.numeric(email): email;

      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: <String, dynamic>{
            "identifier": _email,
            "password": senha,
            //"Token": token
          }
      );

      if (response.isSucess) {
        final user = response.data;
        final UsuarioHoleriteModel _user = UsuarioHoleriteModel.fromMap(user);
        return _user;
      }else{
        throw response.codigo.toString();
      }
    } catch (e){
      debugPrint('Erro UserHoleriteService signInAuth: $e');
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


  /// metodo inativo
  Future<bool> deleteUser(int? idUser) async {
    String _metodo = '/holerite/novo/delete';
    try{
      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: <String, dynamic>{
            "Id": idUser
          }
      );

      return response.isSucess;
    } catch (e){
      debugPrint('Erro UserHoleriteService deleteUser: $e');
      return false;
    }
  }
}