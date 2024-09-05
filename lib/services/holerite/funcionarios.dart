
import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import '../../controllers/holerite/user_manager.dart';
import '../../model/holerite/usuario/funcionarios.dart';
import '../http/http.dart';
import '../../config.dart';

class FuncionariosHoleriteService  {
  final HttpCli _http = HttpCli();

  Future<List<DatumFuncionarios>> listFuncionarios() async {
    final String _api = "/employees?pagination[limit]=50&filters[cpf]=${Validacoes.numeric(UserHoleriteManager.user?.user?.cpf)}";

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
          FuncionariosHoleriteModel model = FuncionariosHoleriteModel.fromMap(data);
          return model.data ?? [];
        }
      }

    } catch(e) {
      debugPrint('Erro FuncionariosHoleriteService listFuncionarios: $e');
    }
    return [];
  }

  Future<DatumFuncionarios?> updateFuncionario(
      {int? id,
      String? phone,
      String? email,
      String? typeBank,
      String? codeBank,
      String? accountBank,
      String? pixKeyBank,
      String? agencyBank}) async {

    final String _api = "/employees/$id";
    Map<String, dynamic> body = <String, dynamic>{};

    if(phone != null){
      body['phone'] = phone;
    }
    if(email != null){
      body['email'] = email;
    }
    if(codeBank != null){
      body['codeBank'] = codeBank;
    }
    if(accountBank != null){
      body['accountBank'] = accountBank;
    }
    if(typeBank != null){
      body['typeBank'] = typeBank;
    }
    if(pixKeyBank != null){
      body['pixKeyBank'] = pixKeyBank;
    }
    if(agencyBank != null){
      body['agencyBank'] = agencyBank;
    }

    final MyHttpResponse response = await _http.put(
      url: Config.conf.apiHoleriteEmail! + _api,
      headers: {
        'Authorization': 'Bearer ${UserHoleriteManager.user?.jwt}'
      },
      body: {
        "data": body
      }
    );

    try{
      if(response.isSucess) {
        Map? data = response.data;
        if(data != null && data.containsKey('data')) {
          DatumFuncionarios model = DatumFuncionarios.fromMap(data['data']);
          return model;
        }
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}