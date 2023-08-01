import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../config.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class UserPontoManager extends ChangeNotifier {
  final UserPontoService _service = UserPontoService();
  final BiometriaServices _serviceBio = BiometriaServices();
  final HomePontoService _homeservice = HomePontoService();
  final SqlitePontoService _sqlService = SqlitePontoService();


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
    usuario = usuario!.copyWith(nome: nome, cargo: cargo, perm: perm, offline: offline, local: local, aponta: aponta);
  }

  Future<bool?> auth(BuildContext context , String email, String senha, bool bio) async {
    bool result = false;
    try {
      if(bio){
        bool _resultBio = await _serviceBio.authbiometria();
        if(_resultBio){
          result = await signInAuth(email: email,  senha: senha);
        }
      }else{
        result = await signInAuth(email: email,  senha: senha);
      }
      return result;
    } catch(e) {
      debugPrint(e.toString());
      CustomSnackbar.context(context, e.toString(), Colors.black87);
    }
  }

  Future<bool> signInAuth({required String email,required String senha}) async {
    usuario = await _service.signInAuth(email: email, senha: senha);
    await getHome();
    if(usuario?.master ?? false){
      UserHoleriteManager.user = UsuarioHolerite.fromPonto(usuario!);
    }
    Config.usenha = senha;
    return true;
  }

  Future<void> getHome() async {
    try {
      HomePontoModel? _home = await _homeservice.getHome(usuario!);
      homeModel = _home;
      updateUser(
          nome: homeModel?.funcionario?.nome,
          cargo: homeModel?.funcionario?.cargo,
          perm: homeModel?.funcionario?.permitirMarcarPonto,
          offline: homeModel?.funcionario?.permitirMarcarPontoOffline,
          local: homeModel?.funcionario?.capturarGps
      );
      _sqlService.salvarNovoUsuario( usuario!.toMap() );
    } catch (e) {
      debugPrint('try erro getHome ' + e.toString());
      homeModel = null;
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

  init() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      uemail = prefs.getString("login") ?? '';
      usenha = prefs.getString("usenha") ?? '';
      senha.text = prefs.getString("senha") ?? '';
      email.text = uemail;
      Config.usenha = usenha;
      await autoLogin();
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  signOut() {
    try{
      usuario = null;
      homeModel = null;
    }catch(e){
      debugPrint(e.toString());
    }
  }

}