import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../helper/db.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';

class UserPontoOffilineManager {
  UserPontoOffilineServices _services = UserPontoOffilineServices();

  UserOffilineManager(){
    getUser(EmpresaPontoManager.empresa);
  }

  static List<UserPontoOffine> listUsers = [];


  getUser(EmpresaPontoModel? empresa) async {
    try{
      Database bancoDados = await DbSQL().db;
      String sql = "SELECT * FROM users";

      List users = await bancoDados.rawQuery(sql);

      if(users.isNotEmpty && users.length > 0){
        listUsers = users.map((e) => UserPontoOffine.fromSQL(e)).toList();
      }else{
        if(empresa != null){
          getFuncionariosTablet(empresa);
        }
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  getFuncionariosTablet(EmpresaPontoModel empresa) async {
    try{
      listUsers = await _services.getFuncionariosTablet(empresa);
    }catch (e){
      debugPrint(e.toString());
    }
  }
}