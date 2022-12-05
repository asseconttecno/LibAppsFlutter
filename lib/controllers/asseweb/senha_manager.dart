
import 'package:assecontservices/assecontservices.dart';
import 'package:assecontservices/services/asseweb/senha.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class SenhaAssewebManager {
  final SenhaAssewebService _service = SenhaAssewebService();


  Future<String?> sendPass(String email) async {
    String? result = await _service.sendPass(email: email);
    return result;
  }


  Future<bool> alteracaoPass(BuildContext context, {required String senhaNova,}) async {
    bool? result = await _service.alteracaoPass( senha: senhaNova,);
    if(result ?? false){
      Config.usenha = senhaNova;
      context.read<UserAssewebManager>().senha.text = senhaNova;
      context.read<UserAssewebManager>().memorizar();
    }
    return result ?? false;
  }

}