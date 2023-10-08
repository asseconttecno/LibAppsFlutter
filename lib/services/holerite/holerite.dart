import 'dart:convert';
import 'dart:typed_data';

import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';


import '../../enums/versao_app.dart';
import '../http/http.dart';
import '../../model/model.dart';
import '../../config.dart';

class HoleriteService  {
  final HttpCli _http = HttpCli();

  Future<List<HoleriteModel>> resumoscreen(int idholerite, int mes, int ano) async {
    String _api = "/holeriteresumo/resumoscreen";

    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiHolerite! + _api,
        body: {
          "Id": idholerite, //'13369340000136',
          "month": mes,
          "year": ano,
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
    String _api = "/holeriteresumo/competenciasid";

    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiHolerite! + _api,
        body: {
          "cnpj": user.cnpj.toString(),
          "register": user.registro.toString(),
          "cpf": Config.conf.nomeApp == VersaoApp.HoleriteApp ? null : user.cpf,
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

  Future<File?> holeriteresumo(UsuarioHolerite? user, int idholerite, int mes, int ano, int? tipo) async {
    String _api = "/holeriteresumo";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiHolerite! + _api, decoder: false,
          body: {
            "Id": idholerite,
            "cnpj": user?.cnpj,
            "register": user?.registro,
            "cpf": Config.conf.nomeApp == VersaoApp.HoleriteApp ? null :  user?.cpf,
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


  Future<Uint8List?> holeriteresumoBytes(UsuarioHolerite? user, int idholerite, int mes, int ano, int? tipo) async {
    String _api = "/holeriteresumo/holeriteresumoBytes";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiHolerite! + _api,
          body: {
            "Id": idholerite,
            "cnpj": user?.cnpj,
            "register": user?.registro,
            "cpf": Config.conf.nomeApp == VersaoApp.HoleriteApp ? null :  user?.cpf,
            "month": mes,
            "year": ano,
            "holeriteType": tipo
          }
      );

      if(response.isSucess) {
        final dados = response.data;
        return base64Decode(dados);
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }

}