import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';

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
            "email": user?.email,
            "funcionarioId": user?.userId ,
            "dataInicial": DateFormat('yyyy-MM-dd').format(aponta.datainicio),
            "dataFinal": DateFormat('yyyy-MM-dd').format(aponta.datatermino),
            "statusEspelho": status
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
    String _api = "/api/espelhoPonto";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiEspelho! + _api,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: {
            "email": user?.email,
            "funcionarioId": user?.userId ,
            "dataInicial": DateFormat('yyyy-MM-dd').format(aponta.datainicio),
            "dataFinal": DateFormat('yyyy-MM-dd').format(aponta.datatermino)
          }
      );

      if(response.isSucess) {
        var dadosJson = response.data ;
        EspelhoModel espelhoModel = EspelhoModel.fromMap(dadosJson);
        var htmlContent = '''<!DOCTYPE html>
        <html>
        <head></head>
        <body>${espelhoModel.espelhoHtml}</body>
        </html>
        ''';
        Directory tempDir = await getTemporaryDirectory();
        String savedPath = "Espelho-${aponta.descricao?.replaceAll(' ', '-')}-${DateTime.now().microsecondsSinceEpoch}" ;
        File? file = await FlutterHtmlToPdf.convertFromHtmlContent(
            htmlContent, tempDir.path, savedPath
        );
        espelhoModel.espelho = file;

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