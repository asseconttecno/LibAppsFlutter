import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';


class SenhaManager extends ChangeNotifier {
  SenhaHoleriteService _service = SenhaHoleriteService();

  bool _showSenhaAtual = true;
  bool get showSenhaAtual => _showSenhaAtual;
  set showSenhaAtual(bool v){
    _showSenhaAtual = v;
    notifyListeners();
  }

  bool _showSenhaNova = true;
  bool get showSenhaNova => _showSenhaNova;
  set showSenhaNova(bool v){
    _showSenhaNova = v;
    notifyListeners();
  }

  Future<String?> sendPass({String? email, String? cpf, }) async {
    String? result = await _service.sendPass(email: email, cpf: cpf);
    return result;
  }

  Future<bool?> alteracaoPass(BuildContext context, {required String senha, required String senhaNova,}) async {
    bool? result = await _service.alteracaoPass(id: context.read<UserHoleriteManager>().user!.id!,
        senha: senha, senhaNova: senhaNova);
    Config.senha = senhaNova;
    context.read<UserHoleriteManager>().senha.text = senhaNova;
    context.read<UserHoleriteManager>().memorizar();
    return result;
  }

  ofuscarEmail(String e){
    List<String> _list = e.split('@');
    String email1 = _list.first;
    String email2 = _list.last;
    String asterisco = '*';
    if(email1.length > 2){
      while(asterisco.length < email1.length-2){
        asterisco += '*';
      }
      email1 = email1.replaceRange(2, email1.length, asterisco);
    }
    asterisco = '*';
    List<String> _list2 = email2.split('.');
    while(asterisco.length <= email1.length){
      asterisco += '*';
    }
    email2 = _list2.first.replaceRange(0, _list2.first.length, asterisco);

    if(_list2.length > 1){
      email2 += '.${_list2[1]}';
      if(_list2.length > 2){
        email2 += '.${_list2[2]}';
        if(_list2.length > 3){
          email2 += '.${_list2[3]}';
        }
      }
    }

    return '${email1}@${email2}';
  }
}