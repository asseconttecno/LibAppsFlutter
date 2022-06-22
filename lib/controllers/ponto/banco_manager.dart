
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';

class BancoHorasManager extends ChangeNotifier {
  BancoHorasService _service = BancoHorasService();

  List<BancoHoras> listabanco = [];

  BancoHorasManager(){
    bancoUpdate();
  }

  bancoUpdate(){
    getFuncionarioHistorico(UserPontoManager().usuario);
  }

  signOut(){
    listabanco = [];
  }

  getFuncionarioHistorico(UsuarioPonto? user) async {
    try{
      listabanco = await _service.getFuncionarioHistorico(user);
      notifyListeners();
    }catch(e){
      debugPrint("Erro Try ${e.toString()}");
    }
  }

}