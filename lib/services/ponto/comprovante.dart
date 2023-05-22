
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../../utils/get_file.dart';
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
          url: Config.conf.apiAssepontoNova! + api, decoder: false, isbyte: true,
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
        final dados = response.data ;
        File? file = await CustomFile.fileTemp('pdf', memori: dados);
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