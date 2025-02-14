

import 'package:flutter/material.dart';

import '../../core/repositories/local_service.dart';
import '../../core/service/database_hive.dart';
import '../../model/model.dart';
import '../model/db_model.dart';


class UserLocalSources extends LocalServiceRepo {

  Future<UsuarioPonto?> getUser({int? id, String? email, String? senha}) async {
    List<UserDB> result;
    if (id != null) {
      result = await service.query<UserDB>(DBTableName.users,
          where: (UserDB user) => user.funcionarioId == id
      );
    } else if (email != null && senha != null) {
      result = await service.query<UserDB>(DBTableName.users,
          where: (user) => user.email == email && user.senha == senha
      );
    } else {
      result = await service.query<UserDB>(DBTableName.users);
    }

    if (result.isNotEmpty) {
      UsuarioPonto model = result.first.ponto;
      return model;
    }
    return null;
  }

  Future<int> saveUser({required UsuarioPonto user}) async {
    await deleteUser();
    final u = UserDB.fromPonto(user);
    final result = await service.insert<UserDB>(DBTableName.users, u);
    return result;
  }

  Future<bool> saveUserAll({required List<UsuarioPonto> users}) async {
    try {
      await deleteUser();
      final u = users.map((e) => UserDB.fromPonto(e)).toList();
      final result = await service.insertAll<UserDB>(DBTableName.users, u);
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<void> deleteUser({String? cpf}) async {
    if(cpf != null){
      await service.deleteWhere<UserDB>(DBTableName.users, (v)=> v.cpf == cpf);
    }else{
      await service.deleteWhere<UserDB>(DBTableName.users, (v)=> true);
    }
  }
}
