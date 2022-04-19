import 'dart:io';


import 'package:flutter/material.dart';


import '../../model/holerite/model_holerite.dart';
import '../../model/usuario/users.dart';
import '../../services/holerite/holerite.dart';

class HoleriteManager extends ChangeNotifier {
  HoleriteService _service = HoleriteService();

  List<CompetenciasModel> _listcompetencias = [];
  List<CompetenciasModel> get listcompetencias => _listcompetencias;
  set listcompetencias(List<CompetenciasModel> v){
    _listcompetencias = v;
    notifyListeners();
  }

  Future<List<HoleriteModel>> resumoscreen(Usuario user, int mes, int ano) async {
    List<HoleriteModel> result = await _service.resumoscreen(user, mes, ano);
    return result;
  }

  Future<List<CompetenciasModel>> competencias(Usuario user) async {
    List<CompetenciasModel> result = await _service.competencias(user);
    if(result.isNotEmpty){
      dropdowndata = result.first.descricao ?? 'Holerites';
    }
    return result;

  }

  Future<File?> holeriteresumo(Usuario? user, int mes, int ano, int? tipo) async {
    File? result = await _service.holeriteresumo(user, mes, ano, tipo);
    return result;
  }

  String _dropdowndata = "";
  String get dropdowndata => _dropdowndata;
  set dropdowndata(String v){
    _dropdowndata = v;
    notifyListeners();
  }

  dropdowntipoInit(String v){
    _dropdowntipo = v;
  }

  String _dropdowntipo = "";
  String get dropdowntipo => _dropdowntipo;
  set dropdowntipo(String v){
    _dropdowntipo = v;
    notifyListeners();
  }

}