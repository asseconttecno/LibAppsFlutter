import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';

class UserPontoOffilineManager {
  UserPontoOffilineServices _services = UserPontoOffilineServices();
  final SqlitePontoService _sqlitePonto = SqlitePontoService();

  UserOffilineManager(){
    getUser(EmpresaPontoManager.empresa);
  }

  static List<UserPontoOffine> listUsers = [];


  getUser(EmpresaPontoModel? empresa) async {
    try{
      List? users = await _sqlitePonto.getUser();

      if(users != null && users.isNotEmpty){
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