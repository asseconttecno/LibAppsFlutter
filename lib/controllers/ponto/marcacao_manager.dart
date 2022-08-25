import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class MarcacoesManager extends ChangeNotifier {
  final MarcacoesService _service = MarcacoesService();
  List<Marcacao> listamarcacao = [];

  DateTime _data = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime get data => _data;
  set data(DateTime v){
    _data = DateTime(v.year, v.month, v.day);
    print(_data);
    notifyListeners();
  }


  bool _load = true;
  bool get load => _load;
  set load(v){
    _load = v;
    notifyListeners();
  }

  MarcacaoManager(){
    marcacaoUpdate();
  }

  marcacaoUpdate(){
    getEspelho(UserPontoManager().usuario);
  }

  signOut(){
    listamarcacao = [];
  }

  Future<Marcacao?> getMarcacaoDia() async {
    Marcacao? _marcacao;
    try{
      _marcacao = listamarcacao.firstWhere((e) {
        if(e.datahora != null){
          return DateTime(e.datahora!.year, e.datahora!.month, e.datahora!.day) == data;
        }
        return false;
      });
    }catch (e){
      print(e);
    }
    return _marcacao;
  }

  getEspelho(UsuarioPonto? user) async {
    try{
      listamarcacao = await _service.getEspelho(user);
      notifyListeners();
    }catch(e){
      debugPrint("MarcacoesManager getEspelho Erro Try ${e.toString()}");
    }
  }


}