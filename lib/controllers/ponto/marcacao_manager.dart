import '../../helper/conn.dart';
import '../../model/marcacao/marcacao.dart';
import '../../services/ponto/users.dart';
import '../../settintgs.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

class MarcacaoManager extends ChangeNotifier {
  List<Marcacao> listamarcacao = [];
  ConnectionStatusSingleton _connectionStatus = ConnectionStatusSingleton.getInstance();
  bool _load = true;
  bool get load => _load;
  set load(v){
    _load = v;
    notifyListeners();
  }

  MarcacaoManager(){
    getEspelho();
  }

  marcacaoUpdate(){
    getEspelho();
  }

  signOut(){
    listamarcacao = [];
  }

  getEspelho() async {
    String _api = "api/apontamento/GetEspelho";
    List<Marcacao> listaTemporaria = [];
    try{
      if(await _connectionStatus.checkConnection()){
        final http.Response response = await http.post(Uri.parse(Settings.apiUrl + _api),
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
        if(response.body != null && response.statusCode == 200 && response.body != 'null' && response.body != ''){
          var dadosJson = json.decode( response.body );
          int i = 0;
          while(i < dadosJson["Apontamento"].length){
            listaTemporaria.add(Marcacao.fromMap( dadosJson["Apontamento"][i] ));
            i ++;
          }
          listamarcacao = listaTemporaria;
          notifyListeners();
        }else{
          debugPrint(response.statusCode.toString());
        }
      }

    }catch(e){
      debugPrint("Erro Try ${e.toString()}");
    }
  }


}