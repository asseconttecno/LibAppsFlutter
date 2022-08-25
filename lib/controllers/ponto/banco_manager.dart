
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';

class BancoHorasManager extends ChangeNotifier {
  BancoHorasService _service = BancoHorasService();

  List<BancoHoras> listabanco = [];
  DateTime _data = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime get data => _data;
  set data(DateTime v){
    _data = DateTime(v.year, v.month, v.day);
    notifyListeners();
  }

  BancoHorasManager(){
    bancoUpdate();
  }

  bancoUpdate(){
    getFuncionarioHistorico(UserPontoManager().usuario);
  }

  signOut(){
    listabanco = [];
  }


  Future<BancoHoras?> getBancodia() async {
    BancoHoras? _bancoHoras;
    try{
      _bancoHoras = listabanco.firstWhere((e) {
        if(e.data != null){
          return DateTime(e.data!.year, e.data!.month, e.data!.day) == data;
        }
        return false;
      });
    }catch (e){
      print(e);
    }
    return _bancoHoras;
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