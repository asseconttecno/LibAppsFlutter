import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';
import '../sqlite_ponto.dart';

class UserPontoOffilineServices {
  final HttpCli _http = HttpCli();
  final SqlitePontoService _sqlitePonto = SqlitePontoService();

  Future<List<UserPontoOffine>> getFuncionariosTablet(EmpresaPontoModel empresa) async {
    String _api = "/api/funcionario/GetFuncionariosTablet";
    try{
      final response = await _http.post(
            url: Config.conf.apiAsseponto! + _api,
            body: {
              "database": empresa.database.toString(),
            }
        );
        if (response.isSucess) {
          List<dynamic> dadosJson = response.data;
          if (dadosJson.isNotEmpty && dadosJson.first.containsKey('Id')) {
            List<UserPontoOffine> listUsers = dadosJson.map((e) => UserPontoOffine.fromMap(e)).toList();
            _sqlitePonto.salvarUsers(listUsers);
            return listUsers;
          }
        } else {
          debugPrint(response.codigo.toString());
          debugPrint(response.data.toString());
        }

    } catch (e){
      debugPrint("Erro Try getFuncionariosTablet $e");
    }
    return [];
  }


}