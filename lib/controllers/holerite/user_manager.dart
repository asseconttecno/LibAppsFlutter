import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../../config.dart';



class UserHoleriteManager extends ChangeNotifier {
  UserHoleriteService _service = UserHoleriteService();
  BiometriaServices _serviceBio = BiometriaServices();
  
  UserHoleriteManager(){
    loadBio();
  }

  List<UsuarioHolerite>? listuser;

  UsuarioHolerite? _user;
  UsuarioHolerite? get user => _user;
  set user(UsuarioHolerite? v){
    _user = v;
    notifyListeners();
  }

  final TextEditingController email = TextEditingController();
  final TextEditingController cpf = TextEditingController();
  final TextEditingController senha = TextEditingController();
  String? uemail;
  String? usenha;

  bool _status = false;
  bool get status => _status;
  set status(bool v){
    _status = v;
    notifyListeners();
  }

  memorizar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", email.text);
    await prefs.setString("usenha", senha.text);
    if(status){
      await prefs.setString("senha", senha.text);
    }else if(email.text != uemail){
      await prefs.setString("senha", '');
    }
  }

  Future<bool?> auth(BuildContext context, String email, String senha, bool bio) async {
    bool result = false;
    try{
      if(bio){
        bool _resultBio = await _serviceBio.authbiometria();
        if(_resultBio){
          result = await signInAuth(email: email,  senha: senha);
        }
      }else{
        result = await signInAuth(email: email,  senha: senha);
      }
      return result;
    }catch(e) {
      debugPrint(e.toString());
      CustomSnackbar.context(context, e.toString(), Colors.black87);
    }
  }

  Future<bool> signInAuth({required String email, required String senha}) async {
    listuser = await _service.signInAuth(email: email, senha: senha);
    user = listuser!.first;
    return true;
  }

  signOut(){
    user = null;
  }

  loadBio() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      uemail = (await prefs.getString("user")) ?? '';
      usenha = await prefs.getString("usenha");
      senha.text = await prefs.getString("senha") ?? '';
      email.text = uemail!;
      Config.senha = senha.text;
    } catch(e) {
      debugPrint(e.toString());
    }
  }
}