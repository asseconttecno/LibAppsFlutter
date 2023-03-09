import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config.dart';
import '../../controllers/controllers.dart';
import '../../model/model.dart';
import '../../utils/get_file.dart';
import '../../utils/utils.dart';
import '../http/http.dart';

class ObrigacoesAssewebService {
  final HttpCli _http = HttpCli();

  Future<ObrigacoesDetalhesModel?> obrigacoesdetalhes({int? obrcliperId,}) async {
    String _metodo = '/api/Obrigacao/obrdetails?obrcliperId=${obrcliperId}';

    try {
      MyHttpResponse response = await _http.get(
        url: Config.conf.apiAsseweb! + _metodo,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserAssewebManager.sUser?.token}'
        },
      );

      if (response.isSucess) {
        final result = response.data;

        ObrigacoesDetalhesModel obrigacoesDetalhes = ObrigacoesDetalhesModel.fromMap(result);

        return obrigacoesDetalhes;
      }else{
        debugPrint('ObrigacoesAssewebService - obrigacoesdetalhes: ${response.codigo} ${response.data}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<DateTime>> obrigacoesMes() async {
    String _metodo = '/api/Obrigacao/obrmonthbyuser?userId=${UserAssewebManager.sUser?.login?.id}&clientId=${UserAssewebManager.sCompanies?.id}';

    try {
      MyHttpResponse response = await _http.get(
        url: Config.conf.apiAsseweb! + _metodo,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserAssewebManager.sUser?.token}'
        },
      );

      if (response.isSucess) {
        List result = response.data;
        if(result.isNotEmpty){
          List<DateTime> obrigacoes = result.map((e) => Validacoes.stringToDataBr(e.toString())! ).toList();
          return obrigacoes;
        }
      }else{
        debugPrint('ObrigacoesAssewebService - obrigacoesMes: ${response.codigo} ${response.data}');
      }
    } catch (e) {
      debugPrint('ObrigacoesAssewebService - obrigacoesMes: ${e.toString()}');
    }
    return [];
  }

  Future<List<ObrigacaoModel>> obrigacoesdata({required DateTime date}) async {
    String _metodo = '/api/Obrigacao/obrbydate?userId=${UserAssewebManager.sUser?.login?.id}&clientId=${UserAssewebManager.sCompanies?.id}&date=${DateFormat("yyyy-MM-dd").format(date)}';

    try {
      MyHttpResponse response = await _http.get(
        url: Config.conf.apiAsseweb! + _metodo,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserAssewebManager.sUser?.token}'
        },
      );

      if (response.isSucess) {
        List result = response.data;
        List<ObrigacaoModel> obrigacoes = result.map((e) => ObrigacaoModel.fromMap(e)).toList();
        return obrigacoes;
      }else{
        debugPrint('ObrigacoesAssewebService - obrigacoesdata: ${response.codigo} ${response.data}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<File?> obrigacaoFile({int? idfileObg}) async {
    String _metodo = '/api/Obrigacao/obrfile?obrAqrId=${idfileObg}&clientId=${UserAssewebManager.sCompanies?.id}&recalculo=false';


    try {
      MyHttpResponse response = await _http.get(
        url: Config.conf.apiAsseweb! + _metodo,
        decoder: false, bits: true,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserAssewebManager.sUser?.token}'
        },
      );

      if (response.isSucess) {
        if(response.extencao == 'pdf'){
          Uint8List u = response.data;
          File result = await CustomFile.fileTemp('pdf',memori: u);
          return result;
        }else{
          Uint8List u = response.data;
          File file = await CustomFile.fileTemp('html',memori: u);
          File result = await CustomFile.fileHtml(file);
          return result;
        }
      }else{
        debugPrint('ObrigacoesAssewebService - obrigacaoFile: ${response.codigo} ${response.data}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}
