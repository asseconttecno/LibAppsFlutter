import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../config.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class SenhaPontoManager extends ChangeNotifier {
  final SenhaPontoService _service = SenhaPontoService();

  Future<bool> sendPass(BuildContext context, String email) async {
    try{
      bool result = await _service.sendPass(email);
      return result;
    }catch(e){
      debugPrint("alteracaoPass erro ${e.toString()}");
      return false;
    }
  }

  Future<bool> alteracaoPass(BuildContext context, UsuarioPonto usuario, String atual, String nova) async {
    bool result = await _service.alteracaoPass(usuario.email!, usuario.databaseId!, nova);
    if(result){
      Config.usenha = nova;
      context.read<UserPontoManager>().senha.text = nova;
      context.read<UserPontoManager>().memorizar();
    }
    return result;
  }
}