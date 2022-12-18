import 'package:flutter/material.dart';


import '../../model/model.dart';
import '../../services/services.dart';
import 'user_manager.dart';

class HomeAssewebManager extends ChangeNotifier {
  final HomeAssewebService _service = HomeAssewebService();
  List<ContatosAsseweb> listContatos = [];
  List<ObrigacoesHomeModel> listObrigacoes = [];

  void getHomePage(){
    getContatos();
    getObrigacoesusuarios();
  }

  Future<void> getContatos() async {
    listContatos = await _service.contatos(
        token: UserAssewebManager.sUser?.token ?? '',
        id: UserAssewebManager.sCompanies?.id ?? 0,
    );
    notifyListeners();
  }

  Future<void> getObrigacoesusuarios() async {
    listObrigacoes = await _service.obrigacoesusuarios(
        token: UserAssewebManager.sUser?.token ?? '',
        idcliente: UserAssewebManager.sCompanies?.id ?? 0,
        idusuario: UserAssewebManager.sUser?.login?.id ?? 0,
    );
    listObrigacoes.sort((a,b) => a.obrigacaoClientePeriodo?.deadLine?.compareTo(b.obrigacaoClientePeriodo!.deadLine!) ?? 0);

    notifyListeners();
  }
}