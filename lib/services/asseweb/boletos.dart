import 'package:universal_io/io.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../config.dart';
import '../../controllers/controllers.dart';
import '../../model/model.dart';
import '../../utils/get_file.dart';
import '../http/http.dart';

class BoletosAssewebService {
  final HttpCli _http = HttpCli();

  Future<List<BoletosModel>> getListBoletos({String? cnpj}) async {
    String _metodo = '/api/Boletos';

    try {
      MyHttpResponse response = await _http.post(
        url: Config.conf.apiBoletos! + _metodo,
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'CnpjCpf':  cnpj,
        }
      );

      if (response.isSucess) {
        List result = response.data;
        List<BoletosModel> listBoletos = result.map((e) => BoletosModel.fromMap(e)).toList();
        listBoletos.sort((a,b) => b.dataVencimento!.compareTo(a.dataVencimento!) );

        return listBoletos;
      }else{
        debugPrint('BoletosAssewebService - getListBoletos: ${response.codigo} ${response.data}');
      }
    } catch (e) {
      debugPrint('BoletosAssewebService - getListBoletos: ' + e.toString());
    }
    return [];
  }

  Future<File?> boletoFile(BoletosModel boleto, ) async {

    try {
      MyHttpResponse response = await _http.get(
        url: boleto.url ?? '', decoder: false, bits: true,
      );

      if (response.isSucess) {
        Uint8List u = response.data;
        File result = await CustomFile.fileTemp('pdf',memori: u,
            nome: "boleto_${boleto.numero}_${DateFormat('ddMMyyyy').format(boleto.dataVencimento!)}");
        return result;
      }else{
        debugPrint('BoletosAssewebService - boletoFile: ${response.codigo} ${response.data}');
      }
    } catch (e) {
      debugPrint('BoletosAssewebService - boletoFile: ' + e.toString());
    }
  }

}
