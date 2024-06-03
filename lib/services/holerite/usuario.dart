import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../controllers/holerite/user_manager.dart';
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

  Future<UsuarioHoleriteModel?> registerUser({required String nome,
    required String email, required String senha, required String cpf}) async {
    String _metodo = '/auth/local/register';
    Map<String, dynamic> body = {
      "username": nome,
      "email": email,
      "password": senha,
      "cpf": cpf.replaceAll(".", "").replaceAll("-", "")
    };
    try{
      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: body
      );
      if (response.isSucess) {
        final user = response.data;
        final UsuarioHoleriteModel _user = UsuarioHoleriteModel.fromMap(user);
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
        case "400" :
          throw 'Funcionario já cadastrado';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }

  Future<bool> deleteUser() async {
    String _metodo = '/users/${UserHoleriteManager.user?.user?.id}';
    try{
      MyHttpResponse response = await _http.delete(
        url: Config.conf.apiHoleriteEmail! + _metodo,
        headers: {
          'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}'
        },
      );

      return response.isSucess;
    } catch (e){
      debugPrint('Erro UserHoleriteService deleteUser: $e');
      return false;
    }
  }

  Future<bool> updateUser({String? cpf, String? email, String? username, String? senha }) async {
    String _metodo = '/users/${UserHoleriteManager.user?.user?.id}';
    Map<String, dynamic> body = {};
    if(cpf != null) body['cpf'] = Validacoes.numeric(cpf);
    if(email != null) body['email'] = email;
    if(username != null) body['username'] = username;
    if(senha != null) body['password'] = senha;
    try{
      MyHttpResponse response = await _http.put(
        url: Config.conf.apiHoleriteEmail! + _metodo,
        headers: {
          'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}'
        },
        body: body
      );
      print(response.data);
      return response.isSucess;
    } catch (e){
      debugPrint('Erro UserHoleriteService updateUser: $e');
      return false;
    }
  }
}