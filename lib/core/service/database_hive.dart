import 'package:assecontservices/assecontservices.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../data/model/db_model.dart';

export 'package:hive/hive.dart';

class DatabaseHive {
  static final DatabaseHive _instance = DatabaseHive._internal();
  factory DatabaseHive() => _instance;
  DatabaseHive._internal();

  Box<UserDB>? _userBox;
  //Box<ConfigDB>? _confBox;
  //Box<MarcacaoDB>? _marcBox;

  Future<void> initializeDatabase() async {
    // Registering adapters (if needed)
    if(!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserDBAdapter());
    //if(!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ConfigDBAdapter());
    //if(!Hive.isAdapterRegistered(2)) Hive.registerAdapter(MarcacaoDBAdapter());

    // Opening boxes
    try {
      //if(!Hive.isBoxOpen('confBox')) _confBox = await Hive.openBox<ConfigDB>('confBox');
    } catch (e) {}
    try{
      if(!Hive.isBoxOpen('userBox')) _userBox = await Hive.openBox<UserDB>('userBox');
    } catch (e) {}
    try {
      //if(!Hive.isBoxOpen('marcBox')) _marcBox = await Hive.openBox<MarcacaoDB>('marcBox');
    } catch (e) {}
  }

  Future<Box<UserDB>> get userBox async {
    if (_userBox == null) {
      await initializeDatabase();
    }
    return _userBox!;
  }

/*  Future<Box<ConfigDB>> get confBox async {
    if (_confBox == null) {
      await initializeDatabase();
    }
    return _confBox!;
  }

  Future<Box<MarcacaoDB>> get marcBox async {
    if (_marcBox == null) {
      await initializeDatabase();
    }
    return _marcBox!;
  }*/
}

// Example data classes (if using Hive type adapters)

enum DBTableName {
  users('USERS'),
  conf('CONFIG'),
  marcacoes('MARCACOES');

  final String value;
  const DBTableName(this.value);
}