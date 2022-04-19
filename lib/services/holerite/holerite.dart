import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';

import 'package:webcontent_converter/webcontent_converter.dart';
import 'package:path_provider/path_provider.dart';


import '../http/http_cliente.dart';
import '../http/http_response.dart';
import '../../model/holerite/model_holerite.dart';
import '../../model/usuario/users.dart';
import '../../settintgs.dart';

class HoleriteService  {
  HttpCli _http = HttpCli();

  Future<List<HoleriteModel>> resumoscreen(Usuario user, int mes, int ano) async {
    String _api = "holeriteresumo/resumoscreen";

    final HttpResponse response = await _http.post(
        url: Settings.apiHolerite + _api,
        body: {
          "cnpj": user.cnpj?.toString(), //'13369340000136',
          "register": user.registro?.toString(),
          "month": mes,
          "year": ano,
          "cpf": null//'42585327892'
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

  Future<List<CompetenciasModel>> competencias(Usuario user) async {
    String _api = "holeriteresumo/competencias";

    final HttpResponse response = await _http.post(
        url: Settings.apiHolerite + _api,
        body: {
          "cnpj": user.cnpj.toString(),
          "register": user.registro.toString(),
          "cpf": null,
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

  Future<File?> holeriteresumo(Usuario? user, int mes, int ano, int? tipo) async {
    String _api = "holeriteresumo";
    try{
      final HttpResponse response = await _http.post(
          url: Settings.apiHolerite + _api, decoder: false,
          body: {
            "cnpj": user?.cnpj,
            "register": user?.registro,
            "cpf": user?.funcionarioCpf,
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
        var savedPath = join(tempDir.path, "holerite" + DateTime.now().microsecondsSinceEpoch.toString() + ".pdf");
        await WebcontentConverter.contentToPDF(
          content: htmlContent,
          savedPath: savedPath,
          format: PaperFormat.a4,
          margins: PdfMargins.px(top: 35, bottom: 35, right: 35, left: 35),
        );
        File dadosJson = File(savedPath);
        return dadosJson;
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }


}