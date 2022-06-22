import 'dart:async';
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';



class EspelhoManager extends ChangeNotifier {
  EspelhoService _service = EspelhoService();

  Future<bool> postEspelhoStatus(UsuarioPonto? user, Apontamento aponta, bool status) async {
    bool result = await _service.postEspelhoStatus(user, aponta, status);
    return result;
  }

  Future<EspelhoModel?> postEspelhoPontoPDF(UsuarioPonto? user, Apontamento aponta) async {
    EspelhoModel? result = await _service.postEspelhoPontoPDF(user, aponta);
    return result;
  }


  Apontamento? _apontamento;
  Apontamento? get apontamento => _apontamento;
  set apontamento(Apontamento? v){
    _apontamento = v;
    notifyListeners();
  }

  setMesAtual(Apontamento v){
    print(v);
    _apontamento = v;
    _dropdowndata = v.descricao ?? '';
  }

  String _dropdowndata = "Selecione o Mes";
  String get dropdowndata => _dropdowndata;
  set dropdowndata(String v){
    _dropdowndata = v;
    notifyListeners();
  }

}