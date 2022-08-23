import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import '../ui/espelho/espelho_screen.dart';
import '../ui/home/home.dart';
import '../ui/login/start_screen.dart';
import '../ui/registro/screen_registro.dart';
import '../ui/banco_horas/banco_screen.dart';
import '../ui/marcacoes/Marcacoes.dart';
import '../ui/solicitacoes/solicitacoes_screen.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){

      switch (settings.name) {
        case '/':
          return MaterialPageRoute(
              builder: (_) => IntroScreen()
          );
        case '/login':
          return MaterialPageRoute(
              builder: (_) => StartScreen()
          );
        case '/holerites':
          return MaterialPageRoute(
              builder: (_) => HoleriteScreen()
          );
        case '/espelho':
          return MaterialPageRoute(
              builder: (_) => EspelhoScreen()
          );
        case '/registro':
          return MaterialPageRoute(
              builder: (_) => RegistroScreen()
          );
        case '/home':
          return MaterialPageRoute(
              builder: (_) => Home()
          );
        case '/banco':
          return MaterialPageRoute(
              builder: (_) => BancoHorasScreen()
          );
        case '/marcacoes':
          return MaterialPageRoute(
              builder: (_) => MarcacoesPage(filtro: settings.arguments as int?,)
          );
        case '/solicitacoes':
          return MaterialPageRoute(
              builder: (_) => Solicitacoes()
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