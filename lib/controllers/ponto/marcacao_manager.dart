import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class MarcacoesManager extends ChangeNotifier {
  final MarcacoesService _service = MarcacoesService();
  List<Marcacao> listamarcacao = [];
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

  getEspelho(UsuarioPonto? user) async {
    try{
      listamarcacao = await _service.getEspelho(user);
      notifyListeners();
    }catch(e){
      debugPrint("MarcacoesManager getEspelho Erro Try ${e.toString()}");
    }
  }


}