import 'package:flutter/material.dart';


import '../../model/model.dart';
import '../../services/services.dart';


class PrimeiroAcessoHoleriteManager extends ChangeNotifier{
  final PrimeiroAcessoHoleriteService _service = PrimeiroAcessoHoleriteService();

  PrimeiroAcessoHoleriteModel? acessoModel;

  Future<bool?> verificar(BuildContext context , {required String cnpj, required String registro, }) async {
    acessoModel = await _service.verificar(cnpj: cnpj, registro: registro);
    notifyListeners();
    return acessoModel?.id != 0;
  }

  Future<bool?> esqueceuEmail(BuildContext context , {required String cnpj, required String registro, required String cpf, }) async {
    acessoModel = await _service.esqueceuEmail(cnpj: cnpj, registro: registro, cpf: cpf);
    notifyListeners();
    return acessoModel?.id != 0;
  }

  Future<bool?> cadastrar(BuildContext context, {required String email,
    required String senha, required String cpf, String? cel,}) async {
    bool result = await _service.cadastrar(id: acessoModel!.id!, cel: cel, email: email, senha: senha, cpf: cpf);
    acessoModel = null;
    notifyListeners();
    return result;
  }
}