
import 'dart:convert';

import 'package:universal_io/io.dart';
import 'dart:async';
import 'dart:typed_data';
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
            "DatabaseId": user?.databaseId,
            "FuncionarioId": user?.funcionario?.funcionarioId ,
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

  Future<Uint8List?> postComprovantePDF(UsuarioPonto? user, int marcId) async {
    String api = "/api/comprovantemarcacao/RetornarComprovante";
    try{
      final MyHttpResponse response = await _http.post(
          url: Config.conf.apiAssepontoNova! + api,
          body: {
            "DatabaseId": user?.databaseId,
            "FuncionarioId": user?.funcionario?.funcionarioId ,
            "MarcacaoId": marcId
          }
      );

      if(response.isSucess) {
        final dados = response.data;

        return base64Decode(dados);
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