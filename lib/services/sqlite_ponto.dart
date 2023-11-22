
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../config.dart';
import '../enums/enums.dart';
import '../helper/db_ponto.dart';
import '../model/model.dart';

class SqlitePontoService {
  final DBPonto _service = DBPonto();


  Future<void> salvarNovoUsuario(Map<String, dynamic> toMap) async {
    try{
      Database bancoDados = await _service.db;
      await bancoDados.delete("users");
      await bancoDados.insert("users", toMap);

    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> salvarUsers(List<UserPontoOffine> dados) async {
    try{
      Database bancoDados = await _service.db;

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
      debugPrint("erro salvar users sql $e");
    }
  }

  Future<List?> getUser({String? email, String? senha}) async {
    try{
      Database bancoDados = await _service.db;
      String where = '';
      if(email != null) where = "where email = '$email' and senha = '$senha' ";
      String sql = "SELECT * FROM users $where ";
      List users = await bancoDados.rawQuery(sql);
      return users;
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<List?> getEmpresa() async {
    try{
      Database bancoDados = await _service.db;
      String sql = "SELECT * FROM empresa";

      List users = await bancoDados.rawQuery(sql);
      return users;
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<int> insertEmpresa(Map<String, dynamic> toMap) async {
    try{
      Database bancoDados = await _service.db;
      int config = await bancoDados.insert("empresa", toMap);
      return config;
    }catch(e){
      debugPrint("erro insertConfig sql $e");
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>> getMarcacoes(int? user) async {
    try {
      var bancoDados = await _service.db;
      String sql = "SELECT * FROM marcacao where iduser = ?";
      List _sql = await bancoDados.rawQuery(sql, [user]);
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
      var bancoDados = await _service.db;
      int result = await bancoDados.insert("marcacao", dados.toMap());

      try {
        if(hist) await bancoDados.insert("historico", dados.toHistMap());
      } catch (e) {
        debugPrint("erro salvar marca sql ${e.toString()}");
      }

      return result > 0;
    }catch(e){
      debugPrint("erro salvar marca sql ${e.toString()}");
      return false;
    }
  }

  deleteSalvarMarcacoes(List<Marcacao> del, int? user) async {
    try {
      var bancoDados = await _service.db;
      String sql = "delete FROM marcacao where iduser = ?";
      await bancoDados.rawDelete(sql, [user]);
      await del.map((e) async {
        await salvarMarcacao(e);
      });
    } catch (e) {
      debugPrint("erro sql deleteSalvarMarcacoes ${e.toString()}");
    }
  }

  Future<int> deleteMarcacoes(int? user) async {
    try {
      var bancoDados = await _service.db;
      String sql = "delete FROM marcacao where iduser = ?";
      int _result = await bancoDados.rawDelete(sql, [user]);
      return _result;
    } catch (e) {
      debugPrint("erro sql deleteMarcacoes ${e.toString()}");
      return 0;
    }
  }

  Future<List?> getHistorico(int? user) async {
    try {
      var bancoDados = await _service.db;
      if(user == null){
        String sql =  "select * FROM historico" ;
        List _sql = await bancoDados.rawQuery(sql);
        return _sql;
      }else{
        String sql = "select * FROM historico where iduser = ?";
        List _sql = await bancoDados.rawQuery(sql, [user]);
        return _sql;
      }
    } catch (e) {
      debugPrint("erro getMarcacoes ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>?> getHistoricoFormatado(int? user) async {
    try {
      List? _sql = await getHistorico(user);
      if(_sql != null && _sql.isNotEmpty) {
        List<Map<String, dynamic>> marcacao = _sql.map( (e) => Marcacao.fromSql(e).toSql()  ).toList() ;
        return marcacao;
      }
    }  catch (e) {
      debugPrint("erro getMarcacoes ${e.toString()}");
    }
  }

  deleteHistorico(int? user) async {
    if(Config.conf.nomeApp == VersaoApp.PontoApp){
      try{
        var bancoDados = await _service.db;
        String sql = "SELECT * FROM historico where iduser = ?";
        List _select = await bancoDados.rawQuery(sql, [user]);
        if(_select.isNotEmpty){
          List<Marcacao> _listMarc = _select.map((e) => Marcacao.fromSql(e)).toList();
          String sqlDel = "delete FROM historico where iduser = ?";
          await bancoDados.rawDelete(sqlDel, [user]);
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
      var bancoDados = await _service.db;
      int result = await bancoDados.insert("historico", dados.toHistMap());
      return result > 0;
    }catch(e){
      debugPrint("erro salvar marca sql $e");
      return false;
    }
  }

  Future<List?> initConfig() async {
    try{
      Database bancoDados = await _service.db;
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
      Database bancoDados = await _service.db;
      int config = await bancoDados.insert("config", toMap);
      return config;
    }catch(e){
      debugPrint("erro insertConfig sql $e");
    }
    return 0;
  }

  Future<int> updateConfig(Map<String, dynamic> toMap) async {
    try{
      Database bancoDados = await _service.db;
      int config = await bancoDados.update("config", toMap);
      return config;
    }catch(e){
      debugPrint("erro insertConfig sql $e");
    }
    return 0;
  }


}