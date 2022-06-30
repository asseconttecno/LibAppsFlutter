import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../model/model.dart';
import '../../services/services.dart';


class UserPontoManager extends ChangeNotifier {
  UserPontoService _service = UserPontoService();

  static final  UserPontoManager _userManager = UserPontoManager._internal();
  factory UserPontoManager() {
    return _userManager;
  }
  UserPontoManager._internal();

  UsuarioPonto? _usuario;
  UsuarioPonto? get usuario => _usuario;
  set usuario(UsuarioPonto? valor){
    _usuario = valor;
    notifyListeners();
  }

  bool _regButtom = false;
  bool get regButtom => _regButtom;
  set regButtom(bool valor){
    _regButtom = valor;
    notifyListeners();
  }

  updateUser({String? nome, String? cargo, bool? perm, bool? offline, bool? local, Apontamento? aponta}){
    usuario = usuario!.copyWith(nome: nome, cargo: cargo, perm: perm,
        offline: offline, local: local, aponta: aponta);
  }

  Future<void> signInAuth(BuildContext context, {required String email,required String senha}) async {
    try{
      usuario = await _service.signInAuth(email: email, senha: senha);
    }catch(e){
      debugPrint("Erro ${e.toString()}");
      CustomSnackbar.context(context, e.toString(), Colors.red);
    }
  }

  carregaruser(Map<String, dynamic> map){
    usuario = UsuarioPonto.fromMap(map, true);
  }


  signOut() {
    try{
      usuario = null;
    }catch(e){
      debugPrint(e.toString());
    }
  }

}