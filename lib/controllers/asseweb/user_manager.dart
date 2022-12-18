
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../config.dart';
import '../../model/model.dart';
import '../../services/services.dart';


class UserAssewebManager extends ChangeNotifier {
  final UserAssewebService _service = UserAssewebService();
  final BiometriaServices _serviceBio = BiometriaServices();

  UserAssewebManager(){
    loadBio();
  }

  static Company? sCompanies;
  Company? get companies => sCompanies;
  set companies(Company? v){
    sCompanies = v;
    notifyListeners();
  }


  static UsuarioAsseweb? sUser;
  UsuarioAsseweb? get user => sUser;
  set user(UsuarioAsseweb? v){
    sUser = v;
    notifyListeners();
  }

  final TextEditingController email = TextEditingController(text: kReleaseMode ? '' : 'gabriel.mattos.web@gmail.com');
  final TextEditingController senha = TextEditingController(text: kReleaseMode ? '' : 'yinao2');

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
    await prefs.setString("token", user?.token ?? '');
    if(status){
      await prefs.setString("senha", senha.text);
    }else if(email.text != uemail){
      await prefs.setString("senha", '');
    }
  }

  Future<bool?> auth(BuildContext context, String email, String senha, bool bio, {required Null Function() sucess}) async {
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
      memorizar();
      return result;
    }catch(e) {
      debugPrint(e.toString());
      CustomSnackbar.context(context, e.toString(), Colors.black87);
    }
    return null;
  }

  Future<bool> signInAuth({required String email, required String senha}) async {
    user = await _service.signInAuth(email: email, senha: senha);
    if (user != null && (user!.login?.companies?.isNotEmpty ?? false)) {
      companies = user!.login?.companies?.last;
    }
    notifyListeners();
    return true;
  }

  signOut(){
    user = null;
  }

  loadBio() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      uemail = prefs.getString("user");
      usenha = prefs.getString("usenha");
      senha.text = prefs.getString("senha") ?? senha.text;
      email.text = uemail ?? email.text;
      Config.usenha = senha.text;
    } catch(e) {
      debugPrint(e.toString());
    }
  }
}