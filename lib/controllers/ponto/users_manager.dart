import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../config.dart';
import '../../data/local/user_local_sources.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class UserPontoManager extends ChangeNotifier {
  final UserPontoService _service = UserPontoService();
  final BiometriaServices _serviceBio = BiometriaServices();
  final HomePontoService _homeservice = HomePontoService();
  final UserLocalSources _sqlService = UserLocalSources();


  static final  UserPontoManager _userManager = UserPontoManager._internal();
  factory UserPontoManager() {
    return _userManager;
  }
  UserPontoManager._internal(){
    init();
  }

  final TextEditingController email = TextEditingController();
  final TextEditingController senha = TextEditingController();
  String uemail = '';
  String usenha = '';

  bool _status = true;
  bool get status => _status;
  set status(bool v){
    _status = v;
    notifyListeners();
  }

  static UsuarioPonto? susuario;
  UsuarioPonto? get usuario => susuario;
  set usuario(UsuarioPonto? valor){
    susuario = valor;
    notifyListeners();
  }

  updateAponta(Apontamento aponta){
    susuario?.periodo = Periodo(
      dataFinal: aponta.datatermino,
      dataInicial: aponta.datainicio,
      descricao: aponta.descricao
    );
    notifyListeners();
  }

  HomePontoModel? _homeModel;
  HomePontoModel? get homeModel => _homeModel;
  set homeModel(HomePontoModel? valor){
    _homeModel = valor;
    notifyListeners();
  }

  bool _regButtom = false;
  bool get regButtom => _regButtom;
  set regButtom(bool valor){
    _regButtom = valor;
    notifyListeners();
  }

  Future<void> memorizar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("login", email.text);
    await prefs.setString("usenha", usenha);
    //await prefs.setBool("autologin", status);
  }

  Future<void> getHome() async {
    try {
      HomePontoModel? _home = await _homeservice.getHome(usuario!);
      homeModel = _home;

    } catch (e) {
      debugPrint('try erro getHome $e');
      homeModel = null;
    }
  }

  Future<bool?> auth(BuildContext context, String email, String senha, bool bio, String? token, Function(String)? onError) async {
    bool result = false;
    try {
      if(bio){
        bool _resultBio = await _serviceBio.authbiometria();
        if(_resultBio){
          result = await signInAuth(email: email,  senha: usenha, token: token, onError: onError);
        }
      }else{
        result = await signInAuth(email: email,  senha: senha, token: token, onError: onError);
      }
      return result;
    } catch(e) {
      debugPrint(e.toString());
      CustomSnackbar.context(context, e.toString(), Colors.black87);
    }
  }

  Future<bool> signInAuth({required String email,required String senha, String? token, Function(String)? onError}) async {
    final u = await _service.signInAuth(email: email, senha: senha, token: token, onError: onError);
    if(u != null){
      usuario = u;
      Config.usenha = senha;
      usenha = senha;
      _sqlService.saveUser(user: usuario!);
      memorizar();
      return true;
    }else{
      return false;
    }
  }

  Future<bool> signInAuthAuto({required String email,required String senha}) async {
    bool result = false;
    usuario = await _service.authOffiline(email, senha);
    if(usuario == null){
      result = await signInAuth(email: uemail, senha: usenha);
    }else{
      signInAuth(email: uemail, senha: usenha);
    }
    Config.usenha = senha;
    usenha = senha;
    return result;
  }

  Future<bool> autoLogin() async {
    bool result = false;
    try {
      result = await signInAuthAuto(email: uemail, senha: usenha);
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  init() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      uemail = prefs.getString("login") ?? '';
      usenha = prefs.getString("usenha") ?? '';
      //_status = prefs.getBool("autologin") ?? false;
      email.text = uemail;
      Config.usenha = usenha;
      //if(_status){
        await autoLogin();
      //}
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  signOut() {
    cleanPreferences();
    usuario = null;
    homeModel = null;
    _status = false;
    uemail = '';
    usenha = '';
    Config.usenha = '';
  }

  cleanPreferences() async {
    try{
      await _service.deleteUser();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("autologin");
      prefs.remove("login");
      prefs.remove("usenha");
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}