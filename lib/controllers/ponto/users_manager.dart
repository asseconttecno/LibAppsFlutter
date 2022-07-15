import 'package:assecontservices/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final TextEditingController email = TextEditingController();
  final TextEditingController senha = TextEditingController();
  String? uemail;
  String? usenha;

  bool _status = false;
  bool get status => _status;
  set status(bool v){
    _status = v;
    notifyListeners();
  }

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

  memorizar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("login", email.text);
    await prefs.setString("usenha", senha.text);
    if(status){
      await prefs.setString("senha", senha.text);
    }else if(email.text != uemail){
      await prefs.setString("senha", '');
    }
  }

  updateUser({String? nome, String? cargo, bool? perm, bool? offline, bool? local, Apontamento? aponta}){
    usuario = usuario!.copyWith(nome: nome, cargo: cargo, perm: perm,
        offline: offline, local: local, aponta: aponta);
  }

  Future<void> signInAuth(BuildContext context, {required String email,required String senha}) async {
    try{
      usuario = await _service.signInAuth(email: email, senha: senha);
      if(usuario?.master ?? false){
        context.read<UserHoleriteManager>().user = UsuarioHolerite.fromPonto(usuario!);
      }
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