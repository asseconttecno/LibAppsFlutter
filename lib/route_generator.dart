import '../settintgs.dart';
import '../ui/smartphone/holerite/holerite.dart';
import '../ui/smartphone/configuracao/configuracao_screen.dart';
import '../ui/smartphone/home/home.dart';
import '../ui/smartphone/intro/intro_screen.dart';
import '../ui/smartphone/login/start_screen.dart';
import '../ui/smartphone/registro/screen_registro.dart';
import '../ui/smartphone/banco_horas/banco_screen.dart';
import '../ui/smartphone/marcacoes/Marcacoes.dart';
import '../ui/smartphone/solicitacoes/solicitacoes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
              builder: (_) => ScreenConfig()
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