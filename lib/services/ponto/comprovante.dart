
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class ComprovanteService {
  final HttpCli _http = HttpCli();

  Future<List<MarcacoesComprovanteModel>> postListarMarcacoes(UsuarioPonto? user, Apontamento aponta) async {
    String api = "/api/comprovantemarcacao/ListarMarcacoes";
    List<MarcacoesComprovanteModel> list = [];
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAssepontoNova! + api,
          body: {
            "DatabaseId": user?.database,
            "FuncionarioId": user?.userId ,
            "DataInicial": DateFormat('yyyy-MM-dd').format(aponta.datainicio),
            "DataFinal": DateFormat('yyyy-MM-dd').format(aponta.datatermino),
          }
      );
      if(response.isSucess) {
        List listMap = response.data;
        list = listMap.map((e) => MarcacoesComprovanteModel.fromMap(e)).toList();
      } else {
        debugPrint(response.codigo.toString());
        debugPrint(response.data.toString());
      }
    } catch(e){
      debugPrint('catch $e');
    }
    return list;
  }

  Future<File?> postComprovantePDF(UsuarioPonto? user, int marcId) async {
    String api = "/api/comprovantemarcacao/RetornarComprovante";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAssepontoNova! + api, decoder: false,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: {
            "DatabaseId": user?.database,
            "FuncionarioId": user?.userId ,
            "MarcacaoId": marcId
          }
      );

      if(response.isSucess) {
        var dados = response.data ;
        var htmlContent = '''<!DOCTYPE html>
        <html>
        <head></head>
        <body>${dados}</body>
        </html>
        ''';
        Directory tempDir = await getTemporaryDirectory();
        String savedPath = "Comprovante-${marcId}-${DateTime.now().microsecondsSinceEpoch}" ;
        File? file = await FlutterHtmlToPdf.convertFromHtmlContent(
            htmlContent, tempDir.path, savedPath
        );

        return file;
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