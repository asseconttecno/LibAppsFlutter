import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';



class HistoricoManager extends ChangeNotifier {
  final SqlitePontoService _sqlitePonto = SqlitePontoService();


  List<HistoricoMarcacoesModel>? _list;
  List<HistoricoMarcacoesModel>? get list => _list;
  set list(List<HistoricoMarcacoesModel>? v){
    _list = v;
    notifyListeners();
  }


  Future<List<HistoricoMarcacoesModel>> getMarcacoes() async {
    List<HistoricoMarcacoesModel> result;
    try{
      List? _select = await _sqlitePonto.getHistorico();
      if(_select != null && _select.isNotEmpty){
        result = _select.map((e) => HistoricoMarcacoesModel.fromMap(e)).toList();
        return result;
      }
    }catch(e){
      debugPrint(e.toString());
    }
    return [];
  }
}