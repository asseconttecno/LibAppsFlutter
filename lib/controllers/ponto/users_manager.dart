import '../../helper/conn.dart';
import '../../model/apontamento/apontamento.dart';
import '../../model/usuario/users.dart';
import '../../settintgs.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';

import 'home_manager.dart';


class UserManager extends ChangeNotifier {
  ConnectionStatusSingleton _connectionStatus = ConnectionStatusSingleton.getInstance();
  static final  UserManager _userManager = UserManager._internal();
  factory UserManager() {
    return _userManager;
  }
  UserManager._internal();

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  set usuario(Usuario? valor){
    _usuario = valor;
    notifyListeners();
  }

  bool _regButtom = false;
  bool get regButtom => _regButtom;
  set regButtom(bool valor){
    _regButtom = valor;
    notifyListeners();
  }

  updateUser({String? nome, String? cargo, bool? perm, bool? offline, bool? local, Apontamento? aponta}){
    usuario = usuario!.copyWith(nome: nome, cargo: cargo, perm: perm,
        offline: offline, local: local, aponta: aponta);
  }

  Future<void> signInAuth({required String email,required String senha, required Function onFail, required Function onSuccess}) async {
    String _api = "api/database/GetDatabaseUserStatus";
    try{
      if(_connectionStatus.hasConnection){
        final http.Response response = await http.post(Uri.parse(Settings.apiUrl  + _api),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              "email": "${email.trim().replaceAll(' ', '')}",
              "pass": "${senha.trim().replaceAll(' ', '')}"
            })
        ).catchError((onError){
          debugPrint("Erro ${onError.toString()}");
          //onFail('Falha ao se conectar, verifique sua conexão com internet', Colors.black87);
        });
        if(response.body != null && response.statusCode == 200 && response.body != 'null' && response.body != ''){
          Map dadosJson = json.decode( response.body );
          if(dadosJson['Status'] == 0){
            signIn(
              email: email,
              senha: senha,
              onSuccess: (){
                onSuccess();
              }, onFail: (e, c){
                onFail(e, Colors.red);
              }
            );
          }else{
            debugPrint('signInAuth ' + dadosJson.toString());
            onFail(dadosJson['Descricao'], Colors.red);
          }
        }else{
          debugPrint(response.statusCode.toString() + '  signInAuth');
          onFail("Login ou Senha Invalido", Colors.red);
        }
      }else{
        debugPrint("signInAuth Sem conexão com internet");
        onFail("Sem conexão com internet", Colors.black87);
      }
    }catch(e){
      debugPrint("Erro ${e.toString()}");
      onFail('Falha ao se conectar, verifique sua conexão com internet', Colors.black87);
    }
  }

  Future<void> signIn({required String email, required String senha, required Function onFail, required Function onSuccess}) async {
    String _api = "api/database/GetDatabaseUser";
    try{
      if(_connectionStatus.hasConnection){
        final http.Response? response = await http.post(Uri.parse(Settings.apiUrl + _api),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              "email": "${email.trim().replaceAll(' ', '')}",
              "pass": "${senha.trim().replaceAll(' ', '')}"
            })
        ).catchError((onError){
          debugPrint("Erro ${onError.toString()}");
          //onFail('Falha ao se conectar, verifique sua conexão com internet', Colors.black87);
        });
        if(response != null && response.body != null && response.statusCode == 200 && response.body != 'null' && response.body != ''){
          Map dadosJson = json.decode( response.body );
          if(dadosJson != null && dadosJson.containsKey('UserId') &&
              dadosJson['UserId'] != null && dadosJson['UserId'] != '' ){
            getPeriodo(
                dadosJson['Database'],
                onSuccess: (aponta) async {
                  usuario = Usuario.fromMap(dadosJson, false, aponta: aponta);
                  onSuccess();
                },
                onFail: (e, c){
                  onFail(e, c);
                }
            );
          }else{
            debugPrint('signIn ' + dadosJson.toString());
            onFail("Falaha ao carregar seu dados, entre em contato com suporte", Colors.red);
          }
        }else{
          debugPrint(response?.statusCode.toString());
          debugPrint(response?.body.toString());
          onFail("Login ou Senha Invalido", Colors.red);
        }
      }else{
        onFail("Sem conexão com internet", Colors.black87);
      }
    }catch(e){
      debugPrint("Erro ${e.toString()}");
      onFail('Falha ao se conectar, verifique sua conexão com internet', Colors.black87);
    }
  }

  getPeriodo(int database, {required Function onFail, required Function onSuccess}) async {
    String _api = "api/apontamento/GetPeriodo";
    try{
      final http.Response response = await http.post(Uri.parse(Settings.apiUrl  + _api),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            "Database": database
          })
      ).catchError((onError){
        debugPrint("Erro ${onError.toString()}");
        //onFail('Falha ao se conectar, verifique sua conexão com internet', Colors.black87);
      });
      if(response != null && response.statusCode == 200){
        Apontamento aponta;
        if(response.body.toString() != 'null'){
          Map? dadosJson = json.decode( response.body );
          aponta = Apontamento.fromMap(dadosJson);
        }else{
          aponta = Apontamento.aponta(descricao: DateFormat('MMMM yyyy').format(DateTime.now()),
              datainicio: DateTime(DateTime.now().year, DateTime.now().month, 1),
              datatermino: DateTime(DateTime.now().year, DateTime.now().month+1, 1).subtract(Duration(days: 1))
          );
        }
        onSuccess(aponta);
      }else{
        debugPrint(response.statusCode.toString() + '  getPeriodo');
        debugPrint(response.body.toString());
        onFail('Não foi possivel carregar o periodo, entre em contato com seu gestor', Colors.black87);
      }
    }catch(e){
      debugPrint("Erro ${e.toString()}");
      onFail('Falha ao se conectar, verifique sua conexão com internet', Colors.black87);
    }
  }

  carregaruser(Map<String, dynamic> map){
    usuario = Usuario.fromMap(map, true);
  }


  signOut() {
    try{
      usuario = null;
      HomeManager().signOut();
    }catch(e){
      debugPrint(e.toString());
    }
  }

}