import 'dart:async';
import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../http/http.dart';


class UsuarioPontoCodigoService {
  final HttpCli _http = HttpCli();

  verificarcodigo(EmpresaPontoModel empresa, String codigo, int tipo) async {
    String _api = "/api/funcionario/RegistroLogin";
    UsuarioPonto? user;
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseponto! + _api,
          body: {
            "database": empresa.database.toString(),
            "registro": codigo
          }
      );

      if(response.isSucess){
        Map dadosJson = response.data ;
        if(dadosJson.toString() != "Registro inálido" && dadosJson.containsKey('Id')){
          user = UsuarioPonto.fromMapTab(dadosJson, codigo);
        }
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