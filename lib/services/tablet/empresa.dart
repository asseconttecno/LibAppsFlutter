import 'package:sqflite/sqflite.dart';

import '../../helper/db.dart';
import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class EmpresaPontoService {
  HttpCli _http = HttpCli();

  Future<bool> salvarEmpresa(EmpresaPontoModel dados) async {
    try{
      Database bancoDados = await DbSQL().db;
      int result = await bancoDados.insert("empresa", dados.toMap());
      if(result > 0){
        return true;
      }
    }catch(e){
      print("erro salvar Empresa sql $e");
    }
    return false;
  }

  Future<EmpresaPontoModel?> signIn(String email, String pass) async {
    String _api = "/api/database/GetDatabaseGestor";
    try{
      final response = await _http.post(
          url: Config.conf.apiAsseponto! + _api,
          body: {
            "email": email,
            "pass": pass
          }
      );

      if(response.isSucess){
        Map dadosJson = response.data;
        if(dadosJson.isNotEmpty && dadosJson.containsKey('Database')){
          EmpresaPontoModel empresa = EmpresaPontoModel.fromJson(dadosJson, pass, email);
          if(empresa.ativado ?? false){
            bool result = await salvarEmpresa(empresa);
            if(result){
              return empresa;
            }
          }
        }
      }else{
        print(response.codigo);
      }
    } catch (e){
      print("Erro Try verificarcodigo $e");
    }
  }
}