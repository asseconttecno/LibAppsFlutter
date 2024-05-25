import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';


import '../../controllers/holerite/user_manager.dart';
import '../../enums/versao_app.dart';
import '../http/http.dart';
import '../../model/model.dart';
import '../../config.dart';

class HoleriteService  {
  final HttpCli _http = HttpCli();

  Future<HoleriteModel?> listHolerite(int page, int pageSize) async {
    String _api = "/holerites?sort=desc&pagination[page]=$page&pagination[pageSize]=${pageSize == 0 ? 25 : pageSize}";
        "&filters[employee]=${UserHoleriteManager.funcSelect?.id}";

    final MyHttpResponse response = await _http.get(
      url: Config.conf.apiHoleriteEmail! + _api,
      headers: {
        'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}'
      },
    );

    try{
      if(response.isSucess) {
        final data = response.data;
        if(data != null) {
          HoleriteModel? model = HoleriteModel.fromMap(data);
          return model;
        }
      }

    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<List<DatumHolerite>> newPageHolerite(int page, int pageSize) async {
    try{
      final result = await listHolerite(page, pageSize);
      if(result != null && result.data != null && result.data!.isNotEmpty) {
        return result.data!;
      }
    } catch(e){
      debugPrint(e.toString());
    }
    return [];
  }

  Future<File?> holeriteresumo(UsuarioHoleriteModel? user, int idholerite, int mes, int ano, int? tipo) async {
    String _api = "/holeriteresumo";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiHolerite! + _api,
          headers: {
            'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}'
          },
          decoder: false,
          body: {
            "Id": idholerite,
            //"cnpj": user?.cnpj,
            //"register": user?.registro,
            "cpf": Config.conf.nomeApp == VersaoApp.HoleriteApp ? null : user?.user?.cpf,
            "month": mes,
            "year": ano,
            "holeriteType": tipo
          }
      );
      if(response.isSucess) {
        var htmlContent = '''<!DOCTYPE html>
        <html>
        <head></head>
        <body>${response.data.toString().replaceAll(' &#x0D;', '').replaceAll(' &#x0D', '')}</body>
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

  Future<Uint8List?> holeriteresumoBytes(UsuarioHoleriteModel? user, int idholerite, int mes, int ano, int? tipo) async {
    String _api = "/holeriteresumo/holeriteresumoBytes";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiHolerite! + _api,
          body: {
            "Id": idholerite,
            //"cnpj": user?.cnpj,
            //"register": user?.registro,
            "cpf": Config.conf.nomeApp == VersaoApp.HoleriteApp ? null :  user?.user?.cpf,
            "month": mes,
            "year": ano,
            "holeriteType": tipo
          }
      );

      if(response.isSucess) {
        final dados = response.data;
        return base64.decode(dados);
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }

}