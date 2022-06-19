import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../helper/db.dart';
import '../../model/model.dart';
import '../../settintgs.dart';
import '../http/http.dart';

class UserPontoOffilineServices {
  HttpCli _http = HttpCli();

  Future<List<UserPontoOffine>> getFuncionariosTablet(EmpresaPontoModel empresa) async {
    String _api = "/api/funcionario/GetFuncionariosTablet";
    try{
      final response = await _http.post(
            url: Settings.conf.apiAsseponto! + _api,
            body: {
              "database": empresa.database.toString(),
            }
        );
        if (response.isSucess) {
          List<dynamic> dadosJson = response.data;
          if (dadosJson.isNotEmpty && dadosJson.length > 0 &&
              dadosJson.first.containsKey('Id')) {
            List<UserPontoOffine> listUsers = dadosJson.map((e) => UserPontoOffine.fromMap(e)).toList();
            salvarUsers(listUsers);
            return listUsers;
          }
        } else {
          print(response.codigo);
          print(response.data);
        }

    } catch (e){
      print("Erro Try getFuncionariosTablet $e");
    }
    return [];
  }

  salvarUsers(List<UserPontoOffine> dados) async {
    try{
      Database bancoDados = await DbSQL().db;
      await bancoDados.delete('users');
      await bancoDados.execute('INSERT INTO users(iduser, nome, pis, registro) VALUES ' +
          dados.map((e) => e.toMap()).toList().toString().replaceAll('[', '').replaceAll(']', '')  );
      String sql = "SELECT * FROM users";
      List _emp = await bancoDados.rawQuery(sql);
      if(_emp.isNotEmpty && _emp.length > 0){
        debugPrint('sucess users');
      }else{
        debugPrint(_emp.toString());
      }
    }catch(e){
      print("erro salvar users sql $e");
    }
  }
}