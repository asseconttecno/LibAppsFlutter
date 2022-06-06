import 'dart:io';
import '../../controllers/ponto/users_manager.dart';
import '../../helper/conn.dart';
import '../../model/memorando/memorando.dart';
import '../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

class MemorandosManager extends ChangeNotifier {
  List<Memorandos> memorandos = [];
  ConnectionStatusSingleton _connectionStatus = ConnectionStatusSingleton.getInstance();

  bool _load = true;
  bool get load => _load;
  set load(v){
    _load = v;
    notifyListeners();
  }

  List<String> justPadrao = [
    "Solicito o abono de meus atrasos ou faltas neste dia",
    'Solicito a inclusão das seguintes marcações neste dia'
  ];

  final TextEditingController controlerObs = TextEditingController(
      text: "Solicito o abono de meus atrasos ou faltas neste dia");

  updateObs(bool marc){
    if(marc && controlerObs.text == justPadrao.first){
      controlerObs.text = justPadrao.last;
    }else if(!marc && controlerObs.text == justPadrao.last){
      controlerObs.text = justPadrao.first;
    }
  }

  File? _foto;
  File? get foto => _foto;
  set foto(File? img){
    _foto = img;
    notifyListeners();
  }

  String _dropdownValue = "Atestado";
  String get dropdownValue => _dropdownValue;
  set dropdownValue(String v){
    _dropdownValue = v;
    notifyListeners();
  }

  TextEditingController controlerData =
  TextEditingController(text: DateFormat("dd/MM/yyyy").format(DateTime.now()));


  MemorandosManager(){
    getMemorandos(UserManager().usuario!.aponta!.datainicio, UserManager().usuario!.aponta!.datatermino);
  }

  memorandosUpdate(){
    getMemorandos(UserManager().usuario!.aponta!.datainicio, UserManager().usuario!.aponta!.datatermino);
  }

  signOut(){
    memorandos = [];
  }

  postMemorando(DateTime data, String texto, int tipo ,{File? img, List<String>? marcacao,
        required Function sucess, required Function error}) async {
    String _api = "api/memorando/PostMemorando";
    String body = '';
    if(await _connectionStatus.checkConnection()){
      if(tipo == 1){
        body = jsonEncode(<String, dynamic>{
          "user": {
            "UserId": "${UserManager().usuario?.userId.toString()}",
            "Database": "${UserManager().usuario?.database.toString()}",
          },
          "data": "${data}",
          "tipo": tipo,
          "Texto": "$texto",
          "arquivonome": img != null ?
            "${UserManager().usuario?.userId}-${DateFormat('dd-MM-yyyy-hh-mm').format(DateTime.now())}.jpg" : null,
          "arquivo": img != null ? base64Encode(img.readAsBytesSync()) : null
        });
      }else if(tipo == 5){
        List<String?> temp = marcacao!.map((e) => e == '' ? null : "${DateFormat('dd/MM/yyyy').format(data)} ${e.toString()}").toList();
        debugPrint(temp.toString());
        body = jsonEncode(<String, dynamic>{
          "user": {
            "UserId": "${UserManager().usuario?.userId.toString()}",
            "Database": "${UserManager().usuario?.database.toString()}",
          },
          "data": "${data}",
          "tipo": tipo,
          "Texto": "$texto",
          "marcacoes": temp
        });
      }

      if(body.isNotEmpty){
        try{
          final http.Response response = await http.post(Uri.parse(Settings.apiUrl + _api),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: body
          );
          if(response.statusCode == 200 && response.body != null && response.body != 'null' && response.body != ''){
            var dadosJson = json.decode( response.body );
            if(dadosJson["IsSuccess"]){
              sucess();
            }else{
              debugPrint(response.statusCode.toString());
              error();
            }
          }else{
            debugPrint(response.statusCode.toString());
            error();
          }
        }catch(e){
          debugPrint("Erro Try ${e.toString()}");
          error();
        }
      }else{
        error();
      }
    }else{
      error();
    }
  }

  getMemorandos(DateTime inicio, DateTime fim) async {
    String _api = "api/memorando/GetMemorandos";
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
                "DataInicial": "${inicio}",
                "DataFinal": "${fim}"
              }
            })
        );
        if(response != null && response.statusCode == 200 && response.body != null &&
            response.body != 'null' && response.body != ''){
          var dadosJson = json.decode( response.body );
          if(dadosJson["IsSuccess"]){
            List<Memorandos> listaTemporaria = [];
            int i = 0;
            while(i < dadosJson["Result"]["Memorandos"].length){
              listaTemporaria.add(Memorandos.fromMap( dadosJson["Result"]["Memorandos"][i] ));
              i ++;
            }
            memorandos = listaTemporaria;
            notifyListeners();
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
