import 'package:flutter/material.dart';

import '../../config.dart';
import '../../model/model.dart';
import '../http/http.dart';

class HomeAssewebService {
  final HttpCli _http = HttpCli();

  Future<List<ContatosAsseweb>> contatos(
      {required String token, required int id}) async {
    String _metodo = '/api/Client/contacts?clientId=${id}';

    try {
      MyHttpResponse response = await _http.get(
        url: Config.conf.apiAsseweb! + _metodo,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
      );

      if (response.isSucess) {
        List result = response.data;

        List<ContatosAsseweb> ListaContatos =
            result.map((e) => ContatosAsseweb.fromMap(e)).toList();

        return ListaContatos;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<Obrigacoes>> obrigacoesusuarios(
      {required String token, required int idcliente, required int idusuario}) async {
    String _metodo = ' /api/Obrigacao/obrbyuser?userId=${idcliente}&clientId=${idusuario}&days=3';

    try {
      MyHttpResponse response = await _http.get(
        url: Config.conf.apiAsseweb! + _metodo,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
      );

      if (response.isSucess) {
        List result = response.data;

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
