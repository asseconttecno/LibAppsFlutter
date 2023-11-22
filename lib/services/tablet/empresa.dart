
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';
import '../sqlite_ponto.dart';


class EmpresaPontoService {
  final HttpCli _http = HttpCli();
  final SqlitePontoService _sqlitePonto = SqlitePontoService();

  Future<bool> salvarEmpresa(EmpresaPontoModel dados) async {
    try{
      int result = await _sqlitePonto.insertEmpresa(dados.toMap());
      if(result > 0){
        return true;
      }
    }catch(e){
      debugPrint("erro salvar Empresa sql $e");
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
        debugPrint(response.codigo.toString());
      }
    } catch (e){
      debugPrint("Erro Try verificarcodigo $e");
    }
  }
}