import 'dart:async';
import '../../helper/conn.dart';
import '../../helper/db.dart';
import '../../model/home/home_model.dart';
import '../../services/usuario/users_manager.dart';
import '../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

class HomeManager extends ChangeNotifier {
  ConnectionStatusSingleton _connectionStatus = ConnectionStatusSingleton.getInstance();

  HomeModel? _homeModel;

  HomeModel? get homeModel => _homeModel;
  set homeModel(HomeModel? valor){
    _homeModel = valor;
    notifyListeners();
  }

  homeUpdate(){
    getHome();
  }

  getHome() async {
    String _api = "api/apontamento/GetHome";
    bool cone = _connectionStatus.hasConnection;
    if(cone){
      if(UserManager().usuario?.userId != null && UserManager().usuario?.database != null){
        try{
          final http.Response response = await http.post(Uri.parse(Settings.apiUrl + Settings.apiUrl2 + _api),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: jsonEncode(<String, dynamic>{
                "User": {
                  "UserId": "${UserManager().usuario?.userId.toString()}",
                  "Database": "${UserManager().usuario?.database.toString()}"
                },
                "Periodo": {
                  "DataInicial": "${UserManager().usuario?.aponta?.datainicio}",
                  "DataFinal": "${UserManager().usuario?.aponta?.datatermino}",
                }
              })
          ).timeout(Duration(seconds: 10), onTimeout:() {
            debugPrint('timeout');
            homeModel = null;
            throw TimeoutException('Erro de Timeout');
          }).catchError((onError){
            debugPrint('catchError');
            debugPrint(onError.toString());
            homeModel = null;
          });

          if(response != null && response.statusCode == 200 && response.body != null
              && response.body != 'null' && response.body != ''){
            var dadosJson = json.decode( response.body );
            homeModel = HomeModel.fromMap(dadosJson);
            await UserManager().updateUser(
              nome: dadosJson['Funcionario']['Nome'],
              cargo: dadosJson['Funcionario']['Cargo'],
              perm: dadosJson['Funcionario']['PermitirMarcarPonto'],
              offline: dadosJson['Funcionario']['PermitirMarcarPontoOffline'],
              local: dadosJson['Funcionario']['CapturarGps']
            );
            saveData();
            notifyListeners();
          }else{
            debugPrint(response.statusCode.toString());
            debugPrint(response.body.toString());
            homeModel = null;
          }

        } on TimeoutException {

          debugPrint("Home TimeoutException");
          homeModel = null;
        }catch(e){
          debugPrint("Home erro ${e.toString()}");
          homeModel = null;
        }
      }
    }else{
      debugPrint("sem conexao");
      if(homeModel != null) homeModel = null;
    }
  }

  signOut(){
    homeModel = null;
  }

  saveData() async {
    try{
      Database bancoDados = await DbSQL().db;
      await bancoDados.delete("usuario");
      await bancoDados.insert("usuario", UserManager().usuario!.toMap());
    }catch(e){
      debugPrint(e.toString());
    }
  }
}