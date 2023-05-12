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

  Future<List<ObrigacoesHomeModel>> obrigacoesusuarios(
      {required String token, required int idcliente, required int idusuario}) async {
    String _metodo = '/api/Obrigacao/obrbyuser?userId=${idusuario}&clientId=${idcliente}&days=20';

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

        List<ObrigacoesHomeModel> obrigacoes =
        result.map((e) => ObrigacoesHomeModel.fromMap(e)).toList();

        return obrigacoes;
      }else{
        debugPrint('HomeAssewebService - obrigacoesusuarios: ${response.codigo}\n${response.data}');
      }
    } catch (e) {
      debugPrint('HomeAssewebService - obrigacoesusuarios: ' + e.toString());
    }
    return [];
  }

}
