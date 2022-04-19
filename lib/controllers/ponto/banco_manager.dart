import '../../helper/conn.dart';
import '../../model/banco_horas/banco_horas.dart';
import '../../services/usuario/users_manager.dart';
import '../../settintgs.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

class BancoManager extends ChangeNotifier {
  List<BancoHoras> listabanco = [];
  ConnectionStatusSingleton _connectionStatus = ConnectionStatusSingleton.getInstance();

  BancoManager(){
    getFuncionarioHistorico();
  }

  bancoUpdate(){
    getFuncionarioHistorico();
  }

  signOut(){
    listabanco = [];
  }

  getFuncionarioHistorico() async {
    String _api = "api/bcohoras/GetFuncionarioHistorico";
    List<BancoHoras> listaTemporaria = [];
    try{
      if(await _connectionStatus.checkConnection()){
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
                "DataFinal": "${UserManager().usuario?.aponta?.datatermino}"
              }
            })
        );
        if(response.statusCode == 200 && response.body != null && response.body != 'null' && response.body != ''){
          var dadosJson = json.decode( response.body );
          if(dadosJson['IsSuccess']){
            int i = 0;
            while(i < dadosJson["Result"]['BancoDiaList'].length){
              listaTemporaria.add(BancoHoras.fromMap( dadosJson["Result"]['BancoDiaList'][i] ));
              i ++;
            }
            listabanco = listaTemporaria;
            notifyListeners();
          }else{
            debugPrint(dadosJson.toString());
          }
        }else{
          debugPrint(response.statusCode.toString());
        }
      }
    }catch(e){
      debugPrint("Erro Try ${e.toString()}");
    }
  }

}