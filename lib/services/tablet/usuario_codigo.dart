import 'dart:async';
import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../http/http.dart';


class UsuarioPontoCodigoService {
  final HttpCli _http = HttpCli();

  Future<UsuarioPonto?> verificarcodigo(int database, String cnpj, String codigo) async {
    String _api = "/api/codigo";
    UsuarioPonto? user;
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAssepontoNova! + _api,
          body: {
            "database": database,
            "cnpj": cnpj,
            "cod": codigo
          }
      );

      if(response.isSucess){
        Map<String, dynamic> dadosJson = response.data ;
        user = UsuarioPonto.fromMap(dadosJson, false);
      }else{
        user = await verificarCodigoOff(codigo);
      }
    } catch (e){
      debugPrint("Erro Try verificarcodigo $e");
      user = await verificarCodigoOff(codigo);
    }
    return user;
  }


  Future<UsuarioPonto?> verificarCodigoOff(String codigo) async {
    try{
      UserPontoOffine? _usuario = UserPontoOffilineManager.listUsers.firstWhere((e) => e.registro == codigo);
      if(_usuario.id != null){
        UsuarioPonto usuario = UsuarioPonto.fromOff(_usuario);
        return usuario;
      }
    }catch(e){
      debugPrint('verificarCodigoOff $e');
    }
  }
}