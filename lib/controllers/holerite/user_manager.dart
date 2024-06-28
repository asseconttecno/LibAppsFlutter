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

  memorizar() async {
    final prefs = await SharedPreferences.getInstance();
    await memorizarEmail(prefs);
    await memorizarSenha(prefs);
  }

  memorizarEmail(SharedPreferences prefs) async {
    await prefs.setString("user", email.text);
    if(uemail == '') uemail = email.text;
  }

  memorizarSenha(SharedPreferences prefs) async {
    await prefs.setString("usenha", senha.text);
    if(usenha == '') usenha = senha.text;
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

  Future<bool> signInAuth({required String email, required String senha}) async {
    user = await _service.signInAuth(email: email, senha: senha, token: token);
    if(user?.user?.cpf != null && user?.user?.cpf != ''){
      listFunc = await _serviceFunc.listFuncionarios();
      if(listFunc.isNotEmpty) funcSelect = listFunc.last;
    }
    memorizar();
    notifyListeners();
    return true;
  }

  Future<bool> registerUser({required String email,
    required String senha,required String nome, required String cpf}) async {
    user = await _service.registerUser(email: email, senha: senha, nome: nome, cpf: cpf, );
    listFunc = await _serviceFunc.listFuncionarios();
    if(listFunc.isNotEmpty) funcSelect = listFunc.last;
    memorizar();
    notifyListeners();
    return true;
  }

  Future<bool> updateUser({String? cpf, String? email, String? username}) async {
    bool result = await _service.updateUser(cpf: cpf,
        //email: email ?? user?.user?.email,
        //username: username ?? user?.user?.username,
       // senha: usenha
    );
    if(result){
      if(cpf != null){
        user!.user!.cpf = cpf;
        listFunc = await _serviceFunc.listFuncionarios();
        if(listFunc.isNotEmpty) funcSelect = listFunc.last;
      }
      if(username != null) user!.user!.username = username;
      if(email != null){
        user!.user!.username = email;
        final prefs = await SharedPreferences.getInstance();
        await memorizarEmail(prefs);
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> deleteUser() async {
    bool result = await _service.deleteUser();
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
}