import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';


import '../http/http.dart';
import '../../model/model.dart';
import '../../config.dart';

class HoleriteService  {
  final HttpCli _http = HttpCli();

  Future<List<HoleriteModel>> resumoscreen(UsuarioHolerite user, int mes, int ano) async {
    String _api = "/holeriteresumo/resumoscreen";

    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiHolerite! + _api,
        body: {
          "cnpj": user.cnpj?.toString(), //'13369340000136',
          "register": user.registro?.toString(),
          "month": mes,
          "year": ano,
          "cpf": user.cpf,//'42585327892'
        }
    );

    try{
      if(response.isSucess) {
        List list = response.data;
        if(list.length > 0) {
          List<HoleriteModel> comp = list.map((e) => HoleriteModel.fromMap(e)).toList();
          return comp;
        }
      }

    } catch(e) {
      debugPrint(e.toString());
    }
    return [];

  }

  Future<List<CompetenciasModel>> competencias(UsuarioHolerite user) async {
    String _api = "/holeriteresumo/competencias";

    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiHolerite! + _api,
        body: {
          "cnpj": user.cnpj.toString(),
          "register": user.registro.toString(),
          "cpf": user.cpf,
        }
    );

    try{
      if(response.isSucess) {
        List list = response.data;
        List<CompetenciasModel> comp = CompetenciasModel().fromList(list);
        return comp;
      }
    } catch(e){
      debugPrint(e.toString());
    }
    return [];
  }

  Future<File?> holeriteresumo(UsuarioHolerite? user, int mes, int ano, int? tipo) async {
    String _api = "/holeriteresumo";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiHolerite! + _api, decoder: false,
          body: {
            "cnpj": user?.cnpj,
            "register": user?.registro,
            "cpf": user?.cpf,
            "month": mes,
            "year": ano,
            "holeriteType": tipo
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
        String savedPath = "holerite" + DateTime.now().microsecondsSinceEpoch.toString();
        File? file = await FlutterHtmlToPdf.convertFromHtmlContent(
            htmlContent, tempDir.path, savedPath
        );

        return file;
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }


}