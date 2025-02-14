
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';
import '../sqlite_ponto.dart';

class UserPontoService {
  final HttpCli _http = HttpCli();
  final SqlitePontoService _pontoService = SqlitePontoService();

  Future<UsuarioPonto?> signInAuth({required String email,
    required String senha,String? token, Function(String)? onError}) async {
    String _api = "/api/login";
    UsuarioPonto? _user;
    try {
      final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAssepontoNova! + _api, timeout: 10,
          body: {
            "Email": email.trim().replaceAll(' ', ''),
            "Senha": senha.trim().replaceAll(' ', ''),
            "Token": token
          }
      );

      if(response.isSucess){
        Map<String, dynamic> json = response.data;
        if(json['StatusLogin']['Status'] == 0){
          UsuarioPonto user = UsuarioPonto.fromMap(json, false);
          return user;
        }else{
          _user = await authOffiline(
              email.trim().replaceAll(' ', ''),
              senha.trim().replaceAll(' ', '')
          );
          if (_user != null) {
            return _user;
          }
        }
      }else {
        _user = await authOffiline(
            email.trim().replaceAll(' ', ''),
            senha.trim().replaceAll(' ', '')
        );
        if (_user != null) {
          return _user;
        }
      }
      debugPrint('${response.codigo}  signInAuth');

      if(response.codigo == 404){
        throw "Login ou Senha Invalido";
      }
      if(onError != null) {
        onError('Email:$email, Senha:$senha - \nCodigo:${response.codigo} - \nDados:${response.data}');
      }
      throw "Falha no login, tente novamente mais tarde!";
    } catch (e) {
      _user = await authOffiline(
          email.trim().replaceAll(' ', ''),
          senha.trim().replaceAll(' ', '')
      );
      if(_user != null){
        return _user;
      }else {
        if(e != "Login ou Senha Invalido" && onError != null) {
          onError('Email:$email, Senha:$senha - \nErro:$e');
        }
        debugPrint('$e  signInAuth');
        rethrow;
      }
    }
  }

  Future<UsuarioPonto?> authOffiline(String _email, String _senha) async {
    try{
      List? _user = await _pontoService.getUser(email: _email, senha: _senha);
      if(_user != null && _user.isNotEmpty){
        UsuarioPonto user = UsuarioPonto.fromMap(_user.first, true);
        return user;
      }
    }catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<UsuarioPonto?> authNotificacao() async {
    try{
      List? _user = await _pontoService.getUser();
      if(_user != null && _user.isNotEmpty){
        UsuarioPonto user = UsuarioPonto.fromMap(_user.first, true);
        return user;
      }
    }catch(e) {
      debugPrint(e.toString());
    }
    return null;
  }
}