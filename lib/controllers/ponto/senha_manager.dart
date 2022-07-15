import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../config.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


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

  Future<bool> alteracaoPass(BuildContext context, UsuarioPonto usuario, String atual, String nova) async {
    bool result = await _service.alteracaoPass(usuario, atual, nova);
    if(result){
      Config.senha = nova;
      context.read<UserPontoManager>().senha.text = nova;
      context.read<UserPontoManager>().memorizar();
    }

    return result;
    if(result){
      CustomAlert.sucess(
        context: context,
        mensage: 'Senha Alterada!\n',
      );
    }

  }
}