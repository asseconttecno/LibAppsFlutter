import 'package:flutter/material.dart';

import '../../config.dart';
import '../../controllers/asseweb/user_manager.dart';
import '../http/http.dart';


class SenhaAssewebService {
  HttpCli _http = HttpCli();

  Future<String?> sendPass({String? email,}) async {
    String _metodo = '/api/ExternalLogin/passwordrecover';

    try{

      MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseweb! + _metodo,
          decoder: false,
          body: <String, dynamic>{
            "Email": email,
            "password": null
          }
      );
      if(response.isSucess){
        return 'Sua senha foi enviada para seu e-mail!';
      }
      throw response.codigo.toString();
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case '404' :
          throw 'Email não cadastrado!';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }

  Future<bool?> alteracaoPass({required String senha,}) async {
    String _metodo = '/api/ExternalLogin/changepassword';
    MyHttpResponse? response;

    try{
      response = await _http.post(
          url: Config.conf.apiAsseweb! + _metodo,
          decoder: false,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization' : 'Bearer ${UserAssewebManager.sUser?.token}'
          },
          body: <String, dynamic>{
            "email": UserAssewebManager.sUser?.login?.email,
            "password": senha,
          }
      );
      if(response.isSucess){
        return true;
      }
      throw response.codigo.toString();
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case '404' :
          throw response!.data;
        default :
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }
}