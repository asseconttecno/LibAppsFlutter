import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../enums/enums.dart';
import '../config.dart';


class DBPonto{
  static final  DBPonto _dbhelper = DBPonto._internal();
  Database? _db ;

  factory DBPonto() {
    return _dbhelper;
  }

  DBPonto._internal() {
    if(Config.isWin) sqfliteFfiInit();
    db;
  }

  int versaoNew = 6;
  int versao = 1;

  Future<Database> get db async {
    if(_db == null) {
      _db = await inicializarDB(versao);
    } else if(versao < versaoNew) {
      if(versao < versaoNew){
        versao = await _db!.getVersion();
        _db = await inicializarDB(versaoNew);
        await _db!.setVersion(versaoNew);
        _updateTable(_db!);
        versao = versaoNew;
      }
    }
    return _db!;
  }



  _criardb(Database db, int version) async {
    String sql1 = "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, database int, nome VARCHAR, email VARCHAR, pis VARCHAR, funcionarioCpf VARCHAR, registro VARCHAR, cnpj VARCHAR,  master VARCHAR, connected VARCHAR, cargo VARCHAR, apontamento VARCHAR, datainicio DATETIME, datatermino DATETIME, permitirMarcarPonto VARCHAR, permitirMarcarPontoOffline VARCHAR, permitirLocalizacao VARCHAR); ";
    try{
      await db.execute(sql1);
    }catch(e){
      debugPrint(e.toString());
    }
    String sql2 = "CREATE TABLE marcacao (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR, Endereco VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
    try{
      await db.execute(sql2);
    }catch(e){
      debugPrint(e.toString());
    }
    String sql3 = "CREATE TABLE historico (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, nome VARCHAR, cargo VARCHAR, registro VARCHAR, pis VARCHAR, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR,Endereco VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
    try{
      await db.execute(sql3);
    }catch(e){
      debugPrint(e.toString());
    }

    if (Config.conf.nomeApp == VersaoApp.PontoTablet) {
      String sql4 = "CREATE TABLE empresa (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, email VARCHAR, senha VARCHAR, cnpj VARCHAR, ativado VARCHAR, status int, database int ); ";
      try{
        await db.execute(sql4).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }

      String sql5 = "CREATE TABLE config (id INTEGER PRIMARY KEY AUTOINCREMENT, email VARCHAR, status int, hora VARCHAR, local VARCHAR);";
      try{
        await db.execute(sql5).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }

    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    _updateTable(db);
  }

  _updateTable(Database db) async {
    if(versao < 5){
      String sql_update = "CREATE TABLE IF NOT EXISTS historico (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, registro VARCHAR, pis VARCHAR, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR, Endereco VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
      try{
        db.execute(sql_update).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }
      String sql_update3 = "ALTER TABLE historico ADD COLUMN cargo VARCHAR;";
      try{
        db.execute(sql_update3).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }


      String sql_update2 = "ALTER TABLE historico ADD COLUMN nome VARCHAR;";
      try{
        db.execute(sql_update2).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }

      String sql_drop = "DROP TABLE IF EXISTS users;";
      try{
        db.execute(sql_drop).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }
      String sql_drop2 = "DROP TABLE IF EXISTS usuario;";
      try{
        db.execute(sql_drop2).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }
      String sql1 = "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, database int, nome VARCHAR, email VARCHAR, pis VARCHAR, funcionarioCpf VARCHAR, registro VARCHAR, cnpj VARCHAR,  master VARCHAR, connected VARCHAR, cargo VARCHAR, apontamento VARCHAR, datainicio DATETIME, datatermino DATETIME, permitirMarcarPonto VARCHAR, permitirMarcarPontoOffline VARCHAR, permitirLocalizacao VARCHAR); ";
      try{
        await db.execute(sql1);
      }catch(e){
        debugPrint(e.toString());
      }
    }
    if(versao <= 6){
      String sql_update3 = "ALTER TABLE historico ADD COLUMN Endereco VARCHAR;";
      try{
        db.execute(sql_update3).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }

      String sql_update2 = "ALTER TABLE marcacao ADD COLUMN Endereco VARCHAR;";
      try{
        db.execute(sql_update2).onError((error, stackTrace) {
          print(error);
        });
      }catch(e){
        debugPrint(e.toString());
      }
    }
  }

  inicializarDB(int v) async {
    final camilhodb = Config.isWin ? await databaseFactoryFfi.getDatabasesPath() : await getDatabasesPath();
    final localdb = join(camilhodb, Config.conf.nomeApp == VersaoApp.PontoApp ? "pontoapp.db" : "pontotab.db");
    if(Config.isWin){
      DatabaseFactory databaseFactory = databaseFactoryFfi;
      Database db = await databaseFactory.openDatabase(localdb,
          options: OpenDatabaseOptions(onCreate: _criardb, version: v, onUpgrade: _onUpgrade));
      return db;
    }else{
      Database db = await openDatabase(localdb, version: v, onCreate: _criardb , onUpgrade: _onUpgrade);
      return db;
    }
  }
}