
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../model/model.dart';
import '../../services/services.dart';


class SenhaPontoManager extends ChangeNotifier {
  SenhaPontoService _service = SenhaPontoService();

  sendPass(BuildContext context, String email) async {
    try{
      bool result = await _service.sendPass(email);
      if(result){
        CustomAlert.sucess(
          context: context,
          mensage: 'Nova senha enviada para seu email!\n',
        );
      }
    }catch(e){
      debugPrint("alteracaoPass erro ${e.toString()}");
      CustomAlert.erro(
        context: context,
        mensage: e.toString(),
      );
    }
  }

  alteracaoPass(BuildContext context, UsuarioPonto usuario, String atual, String nova) async {
    try{
      bool result = await _service.alteracaoPass(usuario, atual, nova);
      if(result){
        CustomAlert.sucess(
          context: context,
          mensage: 'Senha Alterada!\n',
        );
      }
    }catch(e){
      debugPrint("alteracaoPass erro ${e.toString()}");
      CustomAlert.erro(
        context: context,
        mensage: e.toString(),
      );
    }
  }
}