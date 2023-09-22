
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../config.dart';
import '../enums/enums.dart';
import '../helper/db_ponto.dart';
import '../model/model.dart';

class SqlitePontoService {

  salvarNovoUsuario(Map<String, dynamic> toMap) async {
    try{
      Database bancoDados = await DBPonto().db;
      await bancoDados.delete("users");
      await bancoDados.insert("users", toMap);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  salvarUsers(List<UserPontoOffine> dados) async {
    try{
      Database bancoDados = await DBPonto().db;
      await bancoDados.delete('users');
      await bancoDados.execute('INSERT INTO users(iduser, nome, pis, registro) VALUES ' +
          dados.map((e) => e.toMap()).toList().toString().replaceAll('[', '').replaceAll(']', '')  );
      String sql = "SELECT * FROM users";
      List _emp = await bancoDados.rawQuery(sql);
      if(_emp.isNotEmpty){
        debugPrint('sucess users');
      }else{
        debugPrint(_emp.toString());
      }
    }catch(e){
      print("erro salvar users sql $e");
    }
  }

  Future<List?> getUser({String? email}) async {
    try{
      Database bancoDados = await DBPonto().db;
      String where = '';
      if(email != null) where = "where email = '$email' ";
      String sql = "SELECT * FROM users $where ";

      List users = await bancoDados.rawQuery(sql);
      return users;
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<List?> getEmpresa() async {
    try{
      Database bancoDados = await DBPonto().db;
      String sql = "SELECT * FROM empresa";

      List users = await bancoDados.rawQuery(sql);
      return users;
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<int> insertEmpresa(Map<String, dynamic> toMap) async {
    try{
      Database bancoDados = await DBPonto().db;
      int config = await bancoDados.insert("empresa", toMap);
      return config;
    }catch(e){
      debugPrint("erro insertConfig sql $e");
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>> getMarcacoes() async {
    try {
      var bancoDados = await DBPonto().db;
      List _sql = await bancoDados.query("marcacao");
      if(_sql.isNotEmpty) {
        List<Map<String, dynamic>> marcacao = _sql.map((e) => Marcacao().toSql2(e)).toList();
        return marcacao;
      }
    } catch (e) {
      debugPrint("erro getMarcacoes ${e.toString()}");
    }
    return [];
  }

  Future<bool> salvarMarcacao(Marcacao dados, {bool hist = true}) async {
    try{
      var bancoDados = await DBPonto().db;
      int result = await bancoDados.insert("marcacao", dados.toMap());

      try {
        if(hist) await bancoDados.insert("historico", dados.toHistMap());
      } on Exception catch (e) {
        debugPrint("erro salvar marca sql ${e.toString()}");
      }

      return result > 0;
    }catch(e){
      debugPrint("erro salvar marca sql ${e.toString()}");
      return false;
    }
  }

  deleteSalvarMarcacoes(List<Marcacao> del) async {
    var bancoDados = await DBPonto().db;
    await bancoDados.delete("marcacao");
    await del.map((e) async {
      await salvarMarcacao(e);
    });
  }

  Future<int> deleteMarcacoes() async {
    try {
      var bancoDados = await DBPonto().db;
      int _result = await bancoDados.delete("marcacao");
      return _result;
    } on Exception catch (e) {
      debugPrint("erro sql deleteMarcacoes ${e.toString()}");
      return 0;
    }
  }

  Future<List?> getHistorico() async {
    try {
      var bancoDados = await DBPonto().db;
      List _sql = await bancoDados.query("historico");
      return _sql;
    } on Exception catch (e) {
      debugPrint("erro getMarcacoes ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>?> getHistoricoFormatado() async {
    try {
      List? _sql = await getHistorico();
      if(_sql != null && _sql.isNotEmpty) {
        List<Map<String, dynamic>> marcacao = _sql.map( (e) => Marcacao.fromSql(e).toSql()  ).toList() ;
        return marcacao;
      }
    } on Exception catch (e) {
      debugPrint("erro getMarcacoes ${e.toString()}");
    }
  }

  deleteHistorico() async {
    if(Config.conf.nomeApp == VersaoApp.PontoApp){
      try{
        var bancoDados = await DBPonto().db;
        String sql = "SELECT * FROM historico";
        List _select = await bancoDados.rawQuery(sql);
        if(_select.isNotEmpty){
          List<Marcacao> _listMarc = _select.map((e) => Marcacao.fromSql(e)).toList();
          await bancoDados.delete('historico');
          _listMarc.map((e) async {
            if((e.datahora?.difference(DateTime.now()).inDays ?? 100) < 40){
              await salvarHisMarcacao(e);
            }
          }).toList();
        }
      }catch(e){
        debugPrint("erro sql deleteHistorico sql $e");
      }
    }
  }

  Future<bool> salvarHisMarcacao(Marcacao dados) async {
    try{
      var bancoDados = await DBPonto().db;
      int result = await bancoDados.insert("historico", dados.toHistMap());
      return result > 0;
    }catch(e){
      debugPrint("erro salvar marca sql $e");
      return false;
    }
  }

  Future<List?> initConfig() async {
    try{
      Database bancoDados = await DBPonto().db;
      String sql = "SELECT * FROM config";
      List config = await bancoDados.rawQuery(sql);
      return config;
    }catch(e){
      debugPrint("erro initConfig sql $e");
    }
    return null;
  }

  Future<int> insertConfig(Map<String, dynamic> toMap) async {
    try{
      Database bancoDados = await DBPonto().db;
      int config = await bancoDados.insert("config", toMap);
      return config;
    }catch(e){
      debugPrint("erro insertConfig sql $e");
    }
    return 0;
  }

  Future<int> updateConfig(Map<String, dynamic> toMap) async {
    try{
      Database bancoDados = await DBPonto().db;
      int config = await bancoDados.update("config", toMap);
      return config;
    }catch(e){
      debugPrint("erro insertConfig sql $e");
    }
    return 0;
  }


}