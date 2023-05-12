import 'package:flutter/material.dart';

import '../../controllers/asseweb/user_manager.dart';
import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';

class UserAssewebService {
  final HttpCli _http = HttpCli();

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
        Map<String, dynamic> map = response.data;
        final UsuarioAsseweb _user = UsuarioAsseweb.fromMap(map);
        return _user;
      }else{
        debugPrint(response.data.toString());
        debugPrint(response.codigo.toString());
        throw response.codigo.toString();
      }
    } catch (e){
      debugPrint('UserAssewebService signInAuth: ' +  e.toString());
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

  Future<bool> lastcompanyupdate({required int? companyId}) async {
    String _metodo = '/api/ExternalLogin/lastcompanyupdate';
    try{
      MyHttpResponse response = await _http.put(
          url: Config.conf.apiAsseweb! + _metodo,
          body: <String, dynamic>{
            "id": UserAssewebManager.sUser?.login?.id,
            "lastCompanyId": companyId
          }
      );
      return response.isSucess;
    } catch (e){
      debugPrint('UserAssewebService lastcompanyupdate: ' +  e.toString());
    }
    return false;
  }

}