import '../../helper/conn.dart';
import '../../helper/db.dart';
import '../../enums/bio_support_state.dart';
import '../../services/ponto/users.dart';
import '../../settintgs.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class LoginManager extends ChangeNotifier {
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
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

  LoginManager(){
    loadBio();
  }

  auth(String email, String senha, bool bio, BuildContext context ,
      {required Function sucess, required Function erro}) async {
    try{
      if(bio){
        verificarbiometria(
          sucess: (){
            if(connectionStatus.hasConnection){
              UserManager().signInAuth(
                  email: email,  senha: senha,
                  onFail:(e, c){
                    authOffiline(email, senha,
                        sucess: () async {
                          sucess();
                        },erro: (){
                          erro(e, c);
                        }
                    );
                  },
                  onSuccess:() async {
                    sucess();
                  }
              );
            }else{
              authOffiline(email, senha,
                  sucess: (){
                    sucess();
                  },erro: (){
                    erro('Falha ao se conectar, verifique sua conexão com internet', Colors.black87);
                  }
              );
            }
          },erro: (e){
            erro('Falha na autenticação por biometria, utilize sua senha', Colors.black87);
          }
        );
      }else{
        if(connectionStatus.hasConnection){
          UserManager().signInAuth(
              email: email,  senha: senha,
              onFail:(e, c){
                authOffiline(email, senha,
                    sucess: (){
                      sucess();
                    },erro: (){
                      erro(e, c);
                    }
                );
              },
              onSuccess:(){
                sucess();
              }
          );
        }else{
          authOffiline(email, senha,
              sucess: (){
                sucess();
              },erro: (){
                erro('Falha ao se conectar, verifique sua conexão com internet', Colors.black87);
              }
          );
        }
      }
    }catch(e) {
      debugPrint(e.toString());
      erro(e.toString(), Colors.black87);
    }
  }

  loadBio() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      perguntar = (await prefs.getString("perguntar") ?? 'false') == 'true';
      bio = (await prefs.getString("bio") ?? 'false') == 'true';
      uemail = (await prefs.getString("login")) ?? '';
      usenha = await prefs.getString("usenha");
      senha.text = await prefs.getString("senha") ?? '';
      email.text = uemail!;
      Settings.senha = senha.text;
    } catch(e) {
      debugPrint(e.toString());
    }
    try{
      final LocalAuthentication localAuth = LocalAuthentication();
      if(Settings.bioState  == BioSupportState.supported){
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;

        if(canCheckBiometrics) {
          List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
          if(availableBiometrics != null && availableBiometrics.length > 0){
            checkbio = true;
          }
        }
      }
    }catch(e) {
      debugPrint(e.toString());
    }
  }

  authOffiline(String _email, String _senha, {required Function sucess, required Function erro}) async {
    try{
      Database bancoDados = await DbSQL().db;
      String sql = "SELECT * FROM usuario";
      List<Map<String, dynamic>> user = await bancoDados.rawQuery(sql);
      if(user != null && user.length > 0 && (user.first['email'] == _email)
          && (usenha == _senha)){
        UserManager().carregaruser(user.first);
        sucess();
      }else{
        debugPrint(user.toString());
        erro();
      }
    }catch(e) {
      debugPrint(e.toString());
      erro();
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

  notfiBio({required Function sucess}) async {
    final LocalAuthentication localAuth = LocalAuthentication();
    try{
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if(canCheckBiometrics) {
        List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
        if(availableBiometrics != null && availableBiometrics.length > 0){
          checkbio = true;
          if( (!perguntar) && (!bio) ) {
            sucess();
          }
        }else{
          checkbio = false;
        }
      }else{
        checkbio = false;
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> verificarbiometria({required Function sucess, required Function erro}) async {
    try{
      if(Settings.bioState == BioSupportState.supported){
        final LocalAuthentication localAuth = LocalAuthentication();
        bool didAuthenticate = false;
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

          if(didAuthenticate){
            sucess();
          }else{
            erro("didAuthenticate");
          }
        }else{
          erro("availableBiometrics.insNotEmpty");
        }
      }else{
        erro('canCheckBiometrics');
      }
    }catch(e){
      debugPrint(e.toString());
      erro('verificarbiometria ${e.toString()}');
    }
  }
}