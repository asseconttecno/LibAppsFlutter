
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../helper/db.dart';
import '../../model/model.dart';



class HistoricoManager extends ChangeNotifier {
  List<HistoricoMarcacoesModel>? _list;
  List<HistoricoMarcacoesModel>? get list => _list;
  set list(List<HistoricoMarcacoesModel>? v){
    _list = v;
    notifyListeners();
  }


  Future<List<HistoricoMarcacoesModel>> getMarcacoes() async {
    List<HistoricoMarcacoesModel> retur;
    try{
      Database bancoDados = await DbSQL().db;
      String sql = "SELECT * FROM historico";
      List _select = await bancoDados.rawQuery(sql);
      if(_select.isNotEmpty){
        retur = _select.map((e) => HistoricoMarcacoesModel.fromMap(e)).toList();
        return retur;
      }
    }catch(e){
      debugPrint(e.toString());
    }
    return [];
  }
}