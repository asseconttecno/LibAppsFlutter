import 'package:flutter/material.dart';
import '../../config.dart';
import '../../controllers/holerite/user_manager.dart';
import '../../model/holerite/usuario/usuario.dart';
import '../http/http.dart';


class SenhaHoleriteService {
  final HttpCli _http = HttpCli();

  Future<bool?> sendPass({String? email, String? cpf, }) async {
    String _metodo = '/auth/forgot-password';

    try{
      String? _cpf = cpf != null ? cpf.replaceAll('.', '').replaceAll('-', '') : null;
      Map<String, dynamic> body = {
        "email": email,
        //"Cpf": _cpf
      };
      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: body
      );
      if(response.isSucess){
        return response.data['ok'];
      }
      throw response.codigo.toString();
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case "404" :
          throw 'Email não cadastrado!';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }

  Future<UsuarioHoleriteModel?> alteracaoPass({required String senha, required String senhaNova,}) async {
    String _metodo = '/auth/change-password';
    MyHttpResponse? response;
    try{
      response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          headers: {
            'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}'
          },
          body: <String, dynamic>{
            "password": senhaNova,
            "currentPassword": senha,
            "passwordConfirmation": senhaNova
          }
      );
      if(response.isSucess){
        final user = response.data;
        final UsuarioHoleriteModel _user = UsuarioHoleriteModel.fromMap(user);
        return _user;
      }
      throw response.codigo.toString();
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case "404" :
          throw response!.data;
        default :
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }
}