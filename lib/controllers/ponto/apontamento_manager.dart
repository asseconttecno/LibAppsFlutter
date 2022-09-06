import 'package:assecontservices/controllers/controllers.dart';
import 'package:flutter/material.dart';


import '../../model/model.dart';
import '../../services/services.dart';
import '../../config.dart';

class ApontamentoManager extends ChangeNotifier {
  ApontamentoService _service = ApontamentoService();
  List<Apontamento> apontamento = [];

  int _indice = 0;
  int get indice => _indice;
  set indice(int ind){
    _indice = ind;
    notifyListeners();
  }

  ApontamentoManager() {
    getPeriodo(UserPontoManager().usuario);
  }

  signOut(){
    apontamento = [];
  }

  getPeriodo(UsuarioPonto? user) async {
    try{
      List<Apontamento>? aponta = await _service.getPeriodo(user);
      apontamento = aponta;
      notifyListeners();
    }catch(e){
      debugPrint("aponta erro ${e.toString()}");
    }
  }
}
