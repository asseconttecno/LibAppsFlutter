import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../enums/enums.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../../settintgs.dart';



class UserHoleriteManager extends ChangeNotifier {
  UserHoleriteService _service = UserHoleriteService();
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

  bool _perguntar = false;
  bool get perguntar => _perguntar;
  set perguntar(bool v){
    _perguntar = v;
    notifyListeners();
  }

  bool _bio = false;
  bool get bio => _bio;
  set bio(bool v){
    _bio = v;
    saveBiometria();
    notifyListeners();
  }

  bool _checkbio = false;
  bool get checkbio => _checkbio;
  set checkbio(bool v){
    _checkbio = v;
    notifyListeners();
  }

  Future<bool?> auth(BuildContext context, String email, String senha, bool bio) async {
    bool result = false;
    try{
      if(bio){
        bool _resultBio = await verificarbiometria();
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
      perguntar = (await prefs.getString("perguntar") ?? 'false') == 'true';
      bio = (await prefs.getString("bio") ?? 'false') == 'true';
      uemail = (await prefs.getString("user")) ?? '';
      usenha = await prefs.getString("usenha");
      senha.text = await prefs.getString("senha") ?? '';
      email.text = uemail!;
      Settings.senha = senha.text;
    } catch(e) {
      debugPrint(e.toString());
    }
    try{
      if(Settings.bioState  == BioSupportState.supported){
        final LocalAuthentication localAuth = LocalAuthentication();
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;

        if(canCheckBiometrics) {
          List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
          if(availableBiometrics.isNotEmpty){
            checkbio = true;
          }
        }
      }
    }catch(e) {
      debugPrint(e.toString());
    }
  }


  saveBiometria() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("bio", bio.toString());
      await prefs.setString("perguntar", perguntar.toString());
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<bool> notfiBio() async {
    if(Settings.bioState == BioSupportState.supported) {
      final LocalAuthentication localAuth = LocalAuthentication();
      try {
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;

        if (canCheckBiometrics) {
          List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
          if (availableBiometrics.isNotEmpty) {
            checkbio = true;
            if ((!perguntar) && (!bio)) {
              return true;
            }
          } else {
            checkbio = false;
          }
        } else {
          checkbio = false;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return false;
  }

  Future<bool> verificarbiometria() async {
    if(Settings.bioState == BioSupportState.supported){
      final LocalAuthentication localAuth = LocalAuthentication();
      bool didAuthenticate = false;
      try{
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;
        if(canCheckBiometrics){

          List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
          if (availableBiometrics.isNotEmpty){
            const iosStrings =  IOSAuthMessages(
                cancelButton :  'Cancelar' ,
                goToSettingsButton :  'Configurações' ,
                goToSettingsDescription :  'Configure seu ID' ,
                lockOut :  ' Reative seu ID' );

            const andStrings = AndroidAuthMessages(
              cancelButton: 'Cancelar',
              goToSettingsButton: 'Ir para definir',
              biometricNotRecognized: 'Falha ao autenticar',
              goToSettingsDescription: 'Por favor, defina sua autenticação.',
              biometricHint: '',
              biometricSuccess: 'Autenticado com Sucesso',
              signInTitle: 'Aguardando..',
              biometricRequiredTitle: 'Realize sua autenticação',
            );

            didAuthenticate = await localAuth.authenticate(
                localizedReason: 'Por favor autentique-se para continuar',
                useErrorDialogs :  true,
                stickyAuth: true,
                iOSAuthStrings : iosStrings,
                androidAuthStrings: andStrings
            );
          }
        }
        return didAuthenticate;
      }catch(e){
        debugPrint(e.toString());
      }
    }
    return false;
  }
}