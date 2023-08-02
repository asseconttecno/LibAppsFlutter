
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
    _service.lastcompanyupdate(companyId: v?.id);
    notifyListeners();
  }


  static UsuarioAsseweb? sUser;
  UsuarioAsseweb? get user => sUser;
  set user(UsuarioAsseweb? v){
    sUser = v;
    notifyListeners();
  }

  final TextEditingController email = TextEditingController(text: kReleaseMode ? '' : 'gabriel.mattos.web@gmail.com');
  final TextEditingController senha = TextEditingController(text: kReleaseMode ? '' : '123456');

  String uemail = '';
  String usenha = '';

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
    Config.usenha = senha.text;
    if(status){
      await prefs.setString("senha", senha.text);
    }else if(email.text != uemail){
      await prefs.setString("senha", '');
    }
  }

  Future<bool> auth(BuildContext context, {String? email, String? senha, bool bio = false}) async {
    bool result = false;
    try{
      if(bio){
        bool resultBio = await _serviceBio.authbiometria();
        if(resultBio){
          result = await signInAuth(email: uemail,  senha: usenha);
        }
      }else{
        result = await signInAuth(email: email ?? '',  senha: senha ?? '');
      }
      return result;
    }catch(e) {
      debugPrint(e.toString());
      CustomSnackbar.context(context, e.toString(), Colors.black87);
    }
    return result;
  }

  Future<bool> signInAuth({required String email, required String senha}) async {
    sUser = await _service.signInAuth(email: email, senha: senha);
    if (user != null && (user!.login?.companies?.isNotEmpty ?? false)) {
      sCompanies = user!.login?.companies?.firstWhere((e) => e.id == user?.login?.lastCompanyId) ?? user!.login?.companies?.first;
    }
    memorizar();
    notifyListeners();
    return true;
  }

  Future<bool> autoLogin() async {
    bool result = false;
    try {
      if (uemail != '' && usenha != '') {
        result = await signInAuth(email: uemail, senha: usenha);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  signOut(){
    sUser = null;
    sCompanies = null;
    _status = false;
  }

  loadBio() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      uemail = prefs.getString("user") ?? '';
      usenha = prefs.getString("usenha") ?? '';
      senha.text = prefs.getString("senha") ?? senha.text;
      email.text = uemail;
      Config.usenha = senha.text;
    } catch(e) {
      debugPrint(e.toString());
    }
  }
}