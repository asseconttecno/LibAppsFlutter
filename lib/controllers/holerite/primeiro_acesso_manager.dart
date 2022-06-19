import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../model/model.dart';
import '../../services/services.dart';


class PrimeiroAcessoHoleriteManager extends ChangeNotifier{
  PrimeiroAcessoHoleriteService _service = PrimeiroAcessoHoleriteService();
  PrimeiroAcessoHoleriteModel? acessoModel;

  Future<void> verificar(BuildContext context , {required String cnpj, required String registro, }) async {
    try{
      acessoModel = await _service.verificar(cnpj: cnpj, registro: registro);

      if(acessoModel?.id == 0){
        CustomAlert.info(
            context: context,
            mensage: 'Usuario já cadastrado no sistema!',
        );
      }else {
        notifyListeners();
      }
    } catch (error){
      debugPrint(error.toString());
      if(error.toString() == 'Empresa não cadastrada!'){
        PrimeiroAcessoAlert(context);
      }else {
        CustomAlert.erro(
          context: context,
          mensage: error.toString(),
        );
      }
    }
  }

  Future<bool?> esqueceuEmail(BuildContext context ,
      {required String cnpj, required String registro, required String cpf, }) async {
    try{
      acessoModel = await _service.esqueceuEmail(cnpj: cnpj, registro: registro, cpf: cpf);
      notifyListeners();
      return true;
    } catch (error){
      debugPrint(error.toString());
      if(error.toString() == 'Empresa não cadastrada!'){
        PrimeiroAcessoAlert(context);
      }else {
        CustomAlert.erro(
          context: context,
          mensage: error.toString(),
        );
      }
    }
  }

  Future<void> cadastrar(BuildContext context,{ required int id,
      required String email, required String senha, required String cpf, String? cel,}) async {
    try{
      bool result = await _service.cadastrar(id: id, email: email, senha: senha, cpf: cpf);
      if(result){
        acessoModel = null;
        notifyListeners();
        CustomAlert.sucess(
            context: context,
            mensage: 'Usuario cadastrado!',
        );
      }
    } catch (e){
      debugPrint(e.toString());
      CustomAlert.erro(
        context: context,
        mensage: e.toString(),
      );
    }
  }
}