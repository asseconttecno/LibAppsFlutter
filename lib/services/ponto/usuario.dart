
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';

class UserPontoService {
  HttpCli _http = HttpCli();


  Future<UsuarioPonto?> signInAuth({required String email,required String senha,}) async {
    String _api = "api/database/GetDatabaseUserStatus";

      try {
        final MyHttpResponse response = await _http.post(
            url: Config.conf.apiAsseponto! + _api,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: {
                "email": "${email.trim().replaceAll(' ', '')}",
                "pass": "${senha.trim().replaceAll(' ', '')}"
              }
          );

          if(response.isSucess){
            Map dadosJson = response.data;
            if(dadosJson.containsKey('Status') && dadosJson['Status'] == 0){
              signIn(email: email, senha: senha);
            }else if(dadosJson.containsKey('Descricao')){
              debugPrint('signInAuth ' + dadosJson.toString());
              throw dadosJson['Descricao'];
            }else{
              throw "Login ou Senha Invalido";
            }
          }else{
            debugPrint(response.codigo.toString() + '  signInAuth');
            throw "Login ou Senha Invalido";
          }
      } on Exception catch (e) {
        throw e;
      }
  }

  Future<UsuarioPonto?> signIn({required String email, required String senha}) async {
    String _api = "api/database/GetDatabaseUser";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseponto! + _api,
          body:{
            "email": "${email.trim().replaceAll(' ', '')}",
            "pass": "${senha.trim().replaceAll(' ', '')}"
          }
        );

        if(response.isSucess){
          Map dadosJson = response.data;
          if(dadosJson.containsKey('UserId') && dadosJson['UserId'] != null && dadosJson['UserId'] != '' ){
            Apontamento? aponta = await getPeriodo(dadosJson['Database']);
            if(aponta != null){
              UsuarioPonto user = UsuarioPonto.fromMap(dadosJson, false, aponta: aponta);
              return user;
            }else {
              throw "Falaha ao carregar apontamento, entre em contato com suporte";
            }
          }else{
            debugPrint('signIn ' + dadosJson.toString());
            throw "Falaha ao carregar seu dados, entre em contato com suporte";
          }
        }else{
          debugPrint(response.codigo.toString());
          debugPrint(response.data.toString());
          throw "Login ou Senha Invalido";
        }
    }catch(e){
      debugPrint("Erro ${e.toString()}");
      throw e;
    }
  }

  Future<Apontamento?> getPeriodo(int database) async {
    String _api = "api/apontamento/GetPeriodo";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAsseponto! + _api,
          body: {
            "Database": database
          }
      );
      Apontamento aponta = Apontamento.aponta(descricao: DateFormat('MMMM yyyy').format(DateTime.now()),
          datainicio: DateTime(DateTime.now().year, DateTime.now().month, 1),
          datatermino: DateTime(DateTime.now().year, DateTime.now().month+1, 1).subtract(Duration(days: 1)));
      if(response.isSucess && response.data.toString() != 'null'){
        Map dadosJson = response.data;
        aponta = Apontamento.fromMap(dadosJson);
      }else{
        debugPrint(response.codigo.toString() + '  getPeriodo');
        debugPrint(response.data.toString());
      }
      return aponta;
    }catch(e){
      debugPrint("Erro ${e.toString()}");
    }
  }

}