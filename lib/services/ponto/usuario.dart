
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';
import '../sqlite_ponto.dart';

class UserPontoService {
  final HttpCli _http = HttpCli();
  final SqlitePontoService _pontoService = SqlitePontoService();

  Future<UsuarioPonto?> signInAuth({required String email,required String senha,String? token}) async {
    String _api = "/api/login";
    UsuarioPonto? _user;
    try {
      final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAssepontoNova! + _api, timeout: 5,
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
          throw json['StatusLogin']['Descricao'];
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
      throw "Login ou Senha Invalido";
    } catch (e) {
      _user = await authOffiline(email.trim().replaceAll(' ', ''), senha.trim().replaceAll(' ', ''));
      if(_user != null){
        return _user;
      }else {
        debugPrint('$e  signInAuth');
        throw e.toString();
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