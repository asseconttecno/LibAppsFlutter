
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import 'ui/home/home_screen.dart';
import 'ui/informe/informe_screen.dart';
import 'ui/login/start_screen.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings Config){
      switch (Config.name) {
        case '/':
          return MaterialPageRoute(
              builder: (_) => IntroScreen()
          );
        case '/login':
          return MaterialPageRoute(
              builder: (_) => StartScreen()
          );
        case '/home':
          return MaterialPageRoute(
              builder: (_) => HomeScreen()
          );
        case '/holerites':
          return MaterialPageRoute(
              builder: (_) => HoleriteScreen()
          );
        case '/infomes':
          return MaterialPageRoute(
              builder: (_) => InformeRendimentoScreen()
          );
        case '/configuracoes':
          return MaterialPageRoute(
              builder: (_) => ConfigScreen()
          );
        default:
          return _erroRota();
      }

  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(title: Text("Tela não encontrada!"),),
          body: Center(
            child: Text("Tela não encontrada!"),
          ),
        );
      }
    );
  }

}