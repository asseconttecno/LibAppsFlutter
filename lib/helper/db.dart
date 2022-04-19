import '../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class DbSQL{
  static final  DbSQL _dbhelper = DbSQL._internal();
  Database? _db ;

  factory DbSQL() {
    return _dbhelper;
  }

  DbSQL._internal() {
    if(Settings.isWin) sqfliteFfiInit();
    db;
  }

  int versaoNew = 4;
  int versao = 1;

  Future<Database> get db async {
    if(_db == null) {
      _db = await inicializarDB(versao);
    }else {
      versao = await _db!.getVersion();
      if(versao < versaoNew){
        versao = versaoNew;
        _db = await inicializarDB(versaoNew);
        _updateTable();
      }
    }
    return _db!;
  }



  _criardb(Database db, int version) async {
    String sql1 = "CREATE TABLE usuario (userId INTEGER, nome VARCHAR, email VARCHAR, master VARCHAR, connected VARCHAR, funcionarioCpf VARCHAR, registro VARCHAR, cnpj VARCHAR, database int, cargo VARCHAR, apontamento VARCHAR, datainicio DATETIME, datatermino DATETIME, permitirMarcarPonto VARCHAR, permitirMarcarPontoOffline VARCHAR, permitirLocalizacao VARCHAR); ";
    try{
      await db.execute(sql1);
    }catch(e){
      debugPrint(e.toString());
    }
    String sql2 = "CREATE TABLE marcacao (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
    try{
      await db.execute(sql2);
    }catch(e){
      debugPrint(e.toString());
    }
    String sql3 = "CREATE TABLE historico (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, registro VARCHAR, pis VARCHAR, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
    try{
      await db.execute(sql3);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    String sql3 = "CREATE TABLE historico (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, registro VARCHAR, pis VARCHAR, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
    try{
      db.execute(sql3);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  _updateTable() async {
    String sql_update = "CREATE TABLE historico (id INTEGER PRIMARY KEY AUTOINCREMENT, iduser int, registro VARCHAR, pis VARCHAR, datahora VARCHAR, status int, latitude VARCHAR, longitude VARCHAR, obs VARCHAR, imgId VARCHAR, img BLOB);";
    try{
      _db!.execute(sql_update).onError((error, stackTrace) {
        print(error);
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }

  inicializarDB(int v) async {
    final camilhodb = Settings.isWin ? await databaseFactoryFfi.getDatabasesPath() : await getDatabasesPath();
    final localdb = join(camilhodb, "pontoapp.db");
    if(Settings.isWin){
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