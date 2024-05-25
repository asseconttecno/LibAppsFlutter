import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../model/holerite/usuario/funcionarios.dart';
import '../../model/model.dart';
import '../../services/holerite/funcionarios.dart';
import '../../services/services.dart';
import '../../config.dart';



class UserHoleriteManager extends ChangeNotifier {
  final UserHoleriteService _service = UserHoleriteService();
  final FuncionariosHoleriteService _serviceFunc = FuncionariosHoleriteService();
  final BiometriaServices _serviceBio = BiometriaServices();
  
  UserHoleriteManager(){
    loadBio();
  }

  List<DatumFuncionarios> listFunc = [];
  static DatumFuncionarios? funcSelect;

  static String? token;
  static UsuarioHoleriteModel? user;

  final TextEditingController email = TextEditingController();
  final TextEditingController cpf = TextEditingController();
  final TextEditingController senha = TextEditingController();
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
    if(usenha == '') usenha = senha.text;
    if(uemail == '') uemail = email.text;
    Config.usenha = usenha;
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
    user = await _service.signInAuth(email: email, senha: senha, token: token);
    listFunc = await _serviceFunc.listFuncionarios();
    memorizar();
    if(listFunc.isNotEmpty) funcSelect = listFunc.last;
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

  Future<bool> updateFunc({String? accountBank, String? pixKeyBank, String? email,
    String? phone, String? agencyBank, String? typeBank, String? codeBank, }) async {

   final result = await _serviceFunc.updateFuncionario(
     id: funcSelect?.id, phone: phone, email: email, accountBank: accountBank,
     typeBank: typeBank, codeBank: codeBank,  pixKeyBank: pixKeyBank, agencyBank: agencyBank,
   );
   if(result != null){
     funcSelect = result;
     listFunc = listFunc.map((e) => e.id == result.id ? result : e).toList();
     notifyListeners();
     return true;
   }else{
     return false;
   }
  }

  Future<bool> deleteUser() async {
    bool result = true;//await _service.deleteUser(user?.id);
    if(result){
      signOut();
    }
    return result;
  }

  signOut(){
    cleanPreferebces();
    user = null;
    listFunc.clear();
    funcSelect = null;
    _status = false;
    uemail = '';
    usenha = '';
    Config.usenha = '';
  }

  cleanPreferebces() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("user");
      prefs.remove("usenha");
      prefs.remove("senha");
    } catch(e) {
      debugPrint(e.toString());
    }
  }
  loadBio() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      uemail = prefs.getString("user") ?? '';
      usenha = prefs.getString("usenha") ?? '';
      senha.text = prefs.getString("senha") ?? '';
      email.text = uemail;
      Config.usenha = usenha;
      await autoLogin();
    } catch(e) {
      debugPrint(e.toString());
    }
  }
}