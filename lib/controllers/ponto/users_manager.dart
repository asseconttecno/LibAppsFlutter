import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../config.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class UserPontoManager extends ChangeNotifier {
  final UserPontoService _service = UserPontoService();

  static final  UserPontoManager _userManager = UserPontoManager._internal();
  factory UserPontoManager() {
    return _userManager;
  }
  UserPontoManager._internal(){
    init();
  }

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

  Future<bool> auth(BuildContext context , String email, String senha, bool bio) async {
    if(bio){
      bool result = await context.read<BiometriaManager>().verificarbiometria();
      if(result){
        signInAuth(context, email: email,  senha: senha);
      }else{
        throw 'Falha na autenticação por biometria, utilize sua senha!';
      }
    }else{
      signInAuth(context, email: email,  senha: senha);
    }
    return true;
  }

  Future<bool> signInAuth(BuildContext context, {required String email,required String senha}) async {
    usuario = await _service.signInAuth(email: email, senha: senha);
    if(usuario?.master ?? false){
      context.read<UserHoleriteManager>().user = UsuarioHolerite.fromPonto(usuario!);
    }
    return true;
  }

  init() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      uemail = prefs.getString("login") ?? '';
      usenha = prefs.getString("usenha");
      senha.text = prefs.getString("senha") ?? '';
      email.text = uemail!;
      Config.usenha = usenha;
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  signOut() {
    try{
      usuario = null;
    }catch(e){
      debugPrint(e.toString());
    }
  }

}