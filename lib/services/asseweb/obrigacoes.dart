import 'package:universal_io/io.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config.dart';
import '../../controllers/controllers.dart';
import '../../enums/enums.dart';
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
        final List result = response.data;

        ObrigacoesDetalhesModel obrigacoesDetalhes = ObrigacoesDetalhesModel.fromMap(result.first);
        obrigacoesDetalhes.statusTimeLine = StatusTimeLine.statusTimeLine(obrigacoesDetalhes);
        return obrigacoesDetalhes;
      }else{
        debugPrint('ObrigacoesAssewebService - obrigacoesdetalhes: ${response.codigo} ${response.data}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<DateTime>> obrigacoesMes(
      {int? tipo, required DateTime inicio, required DateTime termino}) async {
    String _metodo = '/api/Obrigacao/obrmonthbyuser?userId=${UserAssewebManager.sUser?.login?.id}&clientId=${UserAssewebManager.sCompanies?.id}&obrType=${tipo ?? 0}&startDate=${DateFormat('yyyy-MM-dd').format(inicio)}&endDate=${DateFormat('yyyy-MM-dd').format(termino)}';

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

  Future<List<ObrigacaoModel>> obrigacoesdata({required DateTime date, int? tipo}) async {
    String _metodo = '/api/Obrigacao/obrbydate?userId=${UserAssewebManager.sUser?.login?.id}&clientId=${UserAssewebManager.sCompanies?.id}&obrType=${tipo ?? 0}&date=${DateFormat("yyyy-MM-dd").format(date)}';

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
        Uint8List u = response.data;
        if(response.extencao == 'html'){
          File file = await CustomFile.fileTemp('html',memori: u);
          File result = await CustomFile.fileHtml(file);
          return result;
        }else{
          File result = await CustomFile.fileTemp(response.extencao ?? 'pdf', memori: u);
          return result;
        }
      }else{
        debugPrint('ObrigacoesAssewebService - obrigacaoFile: ${response.codigo} ${response.data}');
      }
    } catch (e) {
      debugPrint('ObrigacoesAssewebService - obrigacaoFile: ${e.toString()}');
    }
  }

}
