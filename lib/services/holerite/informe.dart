import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/model.dart';
import '../../settintgs.dart';
import '../http/http.dart';



class InformeService {
  HttpCli _http = HttpCli();

  Future<List<InformeRendimentosModel>> competencias(UsuarioHolerite? user) async {
    String _api = "informeRendimentos/competencias";
      try{
        final MyHttpResponse response = await _http.post(
            url: Settings.conf.apiHolerite! + _api,
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body:{
              "cnpj":  user?.cnpj ,
              "register": user?.registro ,
              "cpf": user?.registro != null ? null : user?.cpf,
            }
        );
        if(response.isSucess) {
          List list = response.data;
          List<InformeRendimentosModel> comp = list.map((e) => InformeRendimentosModel.fromMap(e)).toList();
          return comp.reversed.toList();
        } else {
          debugPrint(response.codigo.toString());
          debugPrint(response.data.toString());
        }
      } catch(e){
        debugPrint('catch ' + e.toString());
      }
      return [];
  }

  Future<File?> informeRendimentosPDF(UsuarioHolerite user, int? ano) async {
    String _api = "informeRendimentos";
      try{
        final MyHttpResponse response = await _http.post(
            url: Settings.conf.apiHolerite! + _api,
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: {
              "cnpj": user.cnpj ,
              "register": user.registro  ,
              "cpf": user.registro != null ? null : user.cpf,
              "year": ano,
            }
        );
        if(response.isSucess) {
          var htmlContent = '''<!DOCTYPE html>
          <html>
          <head></head>
          <body>${response.data}</body>
          </html>
          ''';
          Directory tempDir = await getTemporaryDirectory();
          String savedPath = "Informe de Rendimentos - " + ano.toString();
          File? file = await FlutterHtmlToPdf.convertFromHtmlContent(
              htmlContent, tempDir.path, savedPath
          );
          return file;
        } else {
          debugPrint(response.codigo.toString());
          return null;
        }
      } catch(e){
        debugPrint(e.toString());
        return null;
      }
  }
}