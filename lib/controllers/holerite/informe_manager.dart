import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';


import '../../model/model.dart';
import '../../services/services.dart';


class InformeManager extends ChangeNotifier {
  InformeService _service = InformeService();

  InformeRendimentosModel? _competencia;
  InformeRendimentosModel? get competencia => _competencia;
  set competencia(InformeRendimentosModel? v){
    _competencia = v;
    notifyListeners();
  }

  List<InformeRendimentosModel> _listcompetencias = [];
  List<InformeRendimentosModel> get listcompetencias => _listcompetencias;
  set listcompetencias(List<InformeRendimentosModel> v){
    _listcompetencias = v;
    notifyListeners();
  }

  Future<void> competencias(UsuarioHolerite user) async {
    try{
      listcompetencias = await _service.competencias(user) ;
      competencia = listcompetencias.first;
      dropdowndata = competencia?.anoReferencia ?? dropdowndata;
    } catch(e){
      debugPrint('catch ' + e.toString());
    }
  }

  Future<File?> informeRendimentosPDF(UsuarioHolerite user, int? ano) async {
      try{
        File? file =  await _service.informeRendimentosPDF(user, ano);
        return file;
      } catch(e){
        debugPrint(e.toString());
        return null;
      }
  }

  String _dropdowndata = "Selecione o Ano";
  String get dropdowndata => _dropdowndata;
  set dropdowndata(String v){
    _dropdowndata = v;
    notifyListeners();
  }

}