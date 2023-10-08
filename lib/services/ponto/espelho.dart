import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:assecontservices/assecontservices.dart';


import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class EspelhoService {
  final HttpCli _http = HttpCli();


  Future<bool> postEspelhoStatus(UsuarioPonto? user, Apontamento aponta, bool status) async {
    String _api = "/api/espelhoStatus";

    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiEspelho! + _api, decoder: false,
          body: {
            "email": user?.funcionario?.email,
            "funcionarioId": user?.funcionario?.funcionarioId ,
            "dataInicial": DateFormat('yyyy-MM-dd').format(aponta.datainicio),
            "dataFinal": DateFormat('yyyy-MM-dd').format(aponta.datatermino),
            "statusEspelho": status,
            "databaseID" : user?.databaseId
          }
      );
      if(response.isSucess) {
        return true;
      } else {
        debugPrint(response.codigo.toString());
        debugPrint(response.data.toString());
      }
    } catch(e){
      debugPrint('catch ' + e.toString());
    }
    return false;
  }

  Future<EspelhoModel?> postEspelhoPontoPDF(UsuarioPonto? user, Apontamento aponta) async {
    String _api = "/api/EspelhoPontoBytes";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiEspelho! + _api,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: {
            "email": user?.funcionario?.email,
            "funcionarioId": user?.funcionario?.funcionarioId ,
            "dataInicial": DateFormat('yyyy-MM-dd').format(aponta.datainicio),
            "dataFinal": DateFormat('yyyy-MM-dd').format(aponta.datatermino),
            "databaseID" : user?.databaseId
          }
      );

      if(response.isSucess) {
        var dadosJson = response.data ;
        EspelhoModel espelhoModel = EspelhoModel.fromMap(dadosJson);
        if(espelhoModel.espelhoHtml != null && !kIsWeb){
          espelhoModel.espelho = await CustomFile.fileTemp('pdf', memori: espelhoModel.espelhoHtml);
        }
/*        var htmlContent = '''${espelhoModel.espelhoHtml}''';
        Directory tempDir = await getTemporaryDirectory();
        String savedPath = "Espelho-${aponta.descricao?.replaceAll(' ', '-')}-${DateTime.now().microsecondsSinceEpoch}" ;
        File? file = await FlutterHtmlToPdf.convertFromHtmlContent(
            htmlContent, tempDir.path, savedPath
        );
        espelhoModel.espelho = file;*/

        return espelhoModel;
      } else {
        debugPrint(response.codigo.toString());
        debugPrint(response.data.toString());
      }
    } catch(e){
      debugPrint(e.toString());
    }
    return null;
  }

}