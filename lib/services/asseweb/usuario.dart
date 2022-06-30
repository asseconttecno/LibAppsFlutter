import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';

class UserAssewebService {
  HttpCli _http = HttpCli();

  Future<UsuarioAsseweb> signInAuth({required String email, required String senha}) async {
    String _metodo = '/api/ExternalLogin/login';
    try{

      MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseweb! + _metodo,
          body: <String, dynamic>{
            "email": email,
            "password": senha
          }
      );

      if (response.isSucess) {
        Map map = response.data;
        final UsuarioAsseweb _user = UsuarioAsseweb.fromMap(map);
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