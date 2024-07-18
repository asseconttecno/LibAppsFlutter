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
    String _api = "/holerites?sort=desc&pagination[page]=$page&pagination[pageSize]=${pageSize == 0 ? 25 : pageSize}&filters[employee]=${UserHoleriteManager.funcSelect?.id}";

    final MyHttpResponse response = await _http.get(
      url: Config.conf.apiHoleriteEmail! + _api,
      headers: {
        'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}'
      },
    );

    try{
      if(response.isSucess) {
        final data = response.data;
        print(data);
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

  Future<Uint8List?> holeriteresumoBytes(int? id) async {
    String _api = "/holerites/generate-pdf";
    try{
      final MyHttpResponse response = await _http.post(
        url: Config.conf.apiHoleriteEmail! + _api, isbyte: true,
        headers: {
          'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Connection': 'keep-alive',
          'Content-Type': 'application/json',
        },
        body: {
          "ids": id
        }
      );

      if(response.isSucess) {
        final dados = response.data;
        return dados;
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }

}