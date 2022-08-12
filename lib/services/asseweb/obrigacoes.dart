import 'package:assecontservices/model/asseweb/usuario/obrigacoes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config.dart';
import '../../model/asseweb/usuario/obrigacoesdetalhes.dart';
import '../http/http.dart';

class ObrigacoesAssewebService {
  HttpCli _http = HttpCli();

  Future<ObrigacoesDetalhes?> obrigacoesdetalhes(
      {required String token, required int obrcliperId,}) async {
    String _metodo = '/api/Obrigacao/obrdetails?obrcliperId=${obrcliperId}';

    try {
      MyHttpResponse response = await _http.get(
        url: Config.conf.apiAsseweb! + _metodo,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
      );

      if (response.isSucess) {
        Map<String, dynamic> result = response.data;

        ObrigacoesDetalhes obrigacoesDetalhes = ObrigacoesDetalhes.fromMap(result);

        return obrigacoesDetalhes;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Obrigacoes>> obrigacoesdata(
      {required String token, required int idcliente, required int idusuario, required DateTime date}) async {
    String _metodo = ' /api/Obrigacao/obrbydate?userId=${idcliente}&clientId=${idusuario}&date=${DateFormat("yyyy-MM-dd").format(date)}';

    try {
      MyHttpResponse response = await _http.get(
        url: Config.conf.apiAsseweb! + _metodo,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
      );

      if (response.isSucess) {
        List<Map<String, dynamic>> result = response.data;

        List<Obrigacoes> obrigacoes =
        result.map((e) => Obrigacoes.fromMap(e)).toList();

        return obrigacoes;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

}
