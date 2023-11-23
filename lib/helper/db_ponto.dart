import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as win;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../enums/enums.dart';
import '../config.dart';


class DBPonto{
  static final  DBPonto _dbhelper = DBPonto._internal();
  factory DBPonto() => _dbhelper;
  DBPonto._internal() {
    if(Config.isWin) win.sqfliteFfiInit();
    init();
  }

  Future<void> init() async {
    versao = await getVersion();
    db;
  }

  static int versaoNew = 8;
  static int versao = 1;

  static Database? _db;
  Future<Database> get db async {
    if(_db == null) {
      versao = versaoNew;
      _db = await inicializarDB(versao);
      _updateTable(_db!);
      setVersion(versaoNew);
    } else if(versao < versaoNew) {
      versao = await getVersion();
      if(versao < versaoNew){
        _db = await inicializarDB(versaoNew);
        _updateTable(_db!);
        versao = versaoNew;
        await setVersion(versaoNew);
      }
    }

    return _db!;
  }



  Future<void> setVersion(int version) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("dbversion", version);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<int> getVersion() async {
    int result = 1;
    try{
      final prefs = await SharedPreferences.getInstance();
      result = prefs.getInt("dbversion") ?? 1;
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }


  _criardb(Database db, int version) async {
    String sql1 = "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, database int, nome VARCHAR, senha VARCHAR, email VARCHAR, pis VARCHAR, funcionarioCpf VARCHAR, registro VARCHAR, cnpj VARCHAR,  master VARCHAR, connected VARCHAR, cargo VARCHAR, apontamento VARCHAR, datainicio DATETIME, datatermino DATETIME, permitirMarcarPonto VARCHAR, permitirMarcarPontoOffline VARCHAR, permitirLocalizacao VARCHAR); ";
    try{
      await db.execute(sql1);
    }catch(e){
    }
    String sql2 = "CREATE TABLE marcacao (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR, Endereco VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
    try{
      await db.execute(sql2);
    }catch(e){
    }
    String sql3 = "CREATE TABLE historico (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, nome VARCHAR, cargo VARCHAR, registro VARCHAR, pis VARCHAR, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR,Endereco VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
    try{
      await db.execute(sql3);
    }catch(e){
    }

    if (Config.conf.nomeApp == VersaoApp.PontoTablet) {
      String sql4 = "CREATE TABLE empresa (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, email VARCHAR, senha VARCHAR, cnpj VARCHAR, ativado VARCHAR, status int, database int ); ";
      try{
        await db.execute(sql4).onError((error, stackTrace) {
          debugPrint(error.toString());
        });
      }catch(e){
      }

      String sql5 = "CREATE TABLE config (id INTEGER PRIMARY KEY AUTOINCREMENT, email VARCHAR, status int, hora VARCHAR, local VARCHAR);";
      try{
        await db.execute(sql5).onError((error, stackTrace) {
          debugPrint(error.toString());
        });
      }catch(e){
      }

    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    _updateTable(db);
  }

  _updateTable(Database db) async {
    if(versao < 6){
      String sql_update = "CREATE TABLE IF NOT EXISTS historico (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, registro VARCHAR, pis VARCHAR, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR, Endereco VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
      try{
        db.execute(sql_update).onError((error, stackTrace) {
        });
      }catch(e){
      }
      String sql_update3 = "ALTER TABLE historico ADD COLUMN cargo VARCHAR;";
      try{
        db.execute(sql_update3).onError((error, stackTrace) {
        });
      }catch(e){
      }


      String sql_update2 = "ALTER TABLE historico ADD COLUMN nome VARCHAR;";
      try{
        db.execute(sql_update2).onError((error, stackTrace) {
        });
      }catch(e){
      }

      String sql1 = "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, database int, nome VARCHAR, senha VARCHAR, email VARCHAR, pis VARCHAR, funcionarioCpf VARCHAR, registro VARCHAR, cnpj VARCHAR,  master VARCHAR, connected VARCHAR, cargo VARCHAR, apontamento VARCHAR, datainicio DATETIME, datatermino DATETIME, permitirMarcarPonto VARCHAR, permitirMarcarPontoOffline VARCHAR, permitirLocalizacao VARCHAR); ";
      try{
        await db.execute(sql1);
      }catch(e){
      }
    }

    if(versao <= 6){
      String sql_update3 = "ALTER TABLE historico ADD COLUMN Endereco VARCHAR;";
      try{
        db.execute(sql_update3).onError((error, stackTrace) {
        });
      }catch(e){
      }

      String sql_update2 = "ALTER TABLE marcacao ADD COLUMN Endereco VARCHAR;";
      try{
        db.execute(sql_update2).onError((error, stackTrace) {
        });
      }catch(e){
      }
    }

    if(versao <= 7){
      String sql_update4 = "ALTER TABLE users ADD COLUMN senha VARCHAR;";
      try{
        db.execute(sql_update4).onError((error, stackTrace) {
        });
      }catch(e){
      }
    }
  }


  Future<Database> inicializarDB(int v) async {
    if(kIsWeb){
      var factory = databaseFactoryFfiWeb;
      Database db = await factory.openDatabase(Config.conf.nomeApp == VersaoApp.PontoApp ? "pontoapp2.db" : "pontotab.db",
          options: OpenDatabaseOptions(onCreate: _criardb, version: v, onUpgrade: _onUpgrade));
      return db;
    }else {
      final camilhodb = Config.isWin ? await win.databaseFactoryFfi.getDatabasesPath() : await getDatabasesPath();
      final localdb = join(camilhodb, Config.conf.nomeApp == VersaoApp.PontoApp ? "pontoapp2.db" : "pontotab.db");


      if(Config.isWin){
        DatabaseFactory databaseFactory = win.databaseFactoryFfi;
        Database db = await databaseFactory.openDatabase(localdb,
            options: OpenDatabaseOptions(onCreate: _criardb, version: v, onUpgrade: _onUpgrade));
        return db;
      } else{
        Database db = await openDatabase(localdb, version: v, onCreate: _criardb , onUpgrade: _onUpgrade);
        return db;
      }
    }
  }
}