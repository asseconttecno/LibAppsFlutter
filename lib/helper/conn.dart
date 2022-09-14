import 'Dart:io';
import 'Dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';

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
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
    print('Connectivity initialize');
    Timer.periodic(const Duration(minutes: 1), (T) async {
      print('Timer $T ' + hasConnection.toString());
      if(hasConnection && (Config.conf.nomeApp == VersaoApp.PontoApp || Config.conf.nomeApp == VersaoApp.PontoTablet)){
        await RegistroManger().enviarMarcacoes();
      }
    });
  }

  Stream get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
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
  }
}