import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class EmpresaPontoManager extends ChangeNotifier {
  final EmpresaPontoService _service = EmpresaPontoService();
  final SqlitePontoService _sqlitePonto = SqlitePontoService();

  static EmpresaPontoModel? empresa;
  static bool autologin = false;

  final TextEditingController email = TextEditingController(text: kReleaseMode ? '' : 'reginal@assecont.com.br');
  final TextEditingController senha = TextEditingController(text: kReleaseMode ? '' : '1');
  bool _load = false;
  bool get load => _load;
  set load(bool v){
    _load = v;
    notifyListeners();
  }

  verificarlogin() async {
    try{
      List? emp = await _sqlitePonto.getEmpresa();

      if(emp != null && emp.isNotEmpty){
        empresa = EmpresaPontoModel.fromSql(emp.first);
        email.text = empresa?.email ?? email.text;
        if(empresa != null){
          UserPontoOffilineManager().getFuncionariosTablet(empresa!);
        }
        autologin = true;
      }else{
        autologin = false;
      }
    }catch(e){
      debugPrint(e.toString());
      autologin = false;
    }
    notifyListeners();
  }

  relogin() async {
    await signIn(
      empresa?.email ?? '',
      empresa?.senha ?? '',
    );
  }

  Future<void> signIn(String email, String pass) async {
    try{
      empresa = await _service.signIn(email, pass);
      if(empresa != null){
        UserPontoOffilineManager().getFuncionariosTablet(empresa!);
      }
      notifyListeners();
    } catch (e){
      print("Erro Try verificarcodigo $e");
    }
  }

  signOut() async {
    try{
      empresa = null;
      notifyListeners();
    }catch(e){
      print(e);
    }
  }
}