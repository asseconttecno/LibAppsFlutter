import 'package:universal_io/io.dart';
import 'Dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../enums/enums.dart';
import '../config.dart';
import '../controllers/controllers.dart';



class ConnectionStatusSingleton {
  static final ConnectionStatusSingleton _singleton = ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  static ConnectionStatusSingleton getInstance() => _singleton;

  bool hasConnection = false;

  StreamController connectionChangeController = StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();
  void initialize() {
    if(!kIsWeb) {
      _connectivity.onConnectivityChanged.listen(_connectionChange);
      checkConnection();
      print('Connectivity initialize');
      if (Config.conf.nomeApp == VersaoApp.PontoApp ||
          Config.conf.nomeApp == VersaoApp.PontoTablet) {
        Timer.periodic(const Duration(minutes: 1), (T) async {
          debugPrint('Timer ${T.tick} ' + hasConnection.toString());
          if (hasConnection) {
            await RegistroManger().enviarMarcacoes();
          }
        });
      }
    }else{
      hasConnection = true;
    }
  }

  Stream get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    if(!kIsWeb){
      bool previousConnection = hasConnection;
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          hasConnection = true;
        } else {
          hasConnection = false;
        }
      } on SocketException catch(_) {
        hasConnection = false;
      }

      if (previousConnection != hasConnection) {
        connectionChangeController.add(hasConnection);
        if(hasConnection){
          if(Config.conf.nomeApp == VersaoApp.PontoApp || Config.conf.nomeApp == VersaoApp.PontoTablet) {
            await RegistroManger().enviarMarcacoes();
          }
        }
      }
      return hasConnection;
    }else{
      hasConnection = true;
      return true;
    }
  }
}