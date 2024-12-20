import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';


import '../../controllers/holerite/user_manager.dart';
import '../http/http.dart';
import '../../model/model.dart';
import '../../config.dart';

class HoleriteService  {
  final HttpCli _http = HttpCli();

  Future<HoleriteModel?> listHolerite(int page, int pageSize) async {
    String _api = "/holerites/by-employee/${UserHoleriteManager.funcSelect?.id}";

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
      debugPrint('HoleriteService listHolerite $e');
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

  Future<Uint8List?> holeriteresumoBytes(int? id, bool isSign, String comp) async {
    String _api = "/holerites/generate-pdf";
    try{
      if(!isSign) await holeriteAss(id, comp);

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


  Future<bool> holeriteAss(int? id, String comp) async {
    String _api = "/holerites/sign-by-employee?employee=${UserHoleriteManager.funcSelect?.id}&competence=$comp";
    try{
      //print(Config.conf.apiHoleriteEmail! + _api);
      //print('Bearer ${UserHoleriteManager.user?.jwt}');

      final MyHttpResponse response = await _http.put(
          url: Config.conf.apiHoleriteEmail! + _api, decoder: false,
          headers: {
            'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}',
            'Content-Type': 'application/json',
          },
          body: {
            "isSigned": true
          }
      );
      //print(response.data);
      //print(response.codigo);
      return response.isSucess;
    } catch(e){
      debugPrint(e.toString());
      return false;
    }
  }
}