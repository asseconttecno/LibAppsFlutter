import '../../helper/conn.dart';
import '../../model/apontamento/apontamento.dart';
import '../../services/usuario/users_manager.dart';
import '../../settintgs.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

class ApontamentoManager extends ChangeNotifier {
  List<Apontamento> apontamento = [];
  ConnectionStatusSingleton _connectionStatus = ConnectionStatusSingleton.getInstance();

  int _indice = 0;
  int get indice => _indice;
  set indice(int ind){
    _indice = ind;
    notifyListeners();
  }

  ApontamentoManager() {
    getPeriodo();
  }

  signOut(){
    apontamento = [];
  }

  getPeriodo() async {
    String _api = "api/apontamento/GetOutrosMeses";
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
              }
            })
        );
        if(response.statusCode == 200 && response.body != null
            && response.body != 'null' && response.body != ''){
          var dadosJson = json.decode( response.body );
          if(dadosJson["Apontamentos"].length > 0){
            List<Apontamento> listaTemporaria = [];
            int i = 0;
            while(i < dadosJson["Apontamentos"].length){
              listaTemporaria.add( Apontamento.fromMap( dadosJson["Apontamentos"][i] ) );
              i ++;
            }
            apontamento = listaTemporaria;
            notifyListeners();
          }
        }else{
          debugPrint(response.statusCode.toString());
        }
      }
    }catch(e){
      debugPrint("aponta erro ${e.toString()}");
    }
  }
}
