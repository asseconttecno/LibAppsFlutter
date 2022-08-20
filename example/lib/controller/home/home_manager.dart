import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';


class HomeManager extends ChangeNotifier {
  final HomePontoService _service = HomePontoService();
  final SqlitePontoService _pontoService = SqlitePontoService();

  HomePontoModel? _homeModel;
  HomePontoModel? get homeModel => _homeModel;
  set homeModel(HomePontoModel? valor){
    _homeModel = valor;
    notifyListeners();
  }

  homeUpdate(){
    getHome();
  }

  getHome() async {
    try {
      BuildContext? context = Config.scaffoldKey.currentContext;
      UsuarioPonto? user = context?.read<UserPontoManager>().usuario;
      print('getHome');print(context);
      if(context != null && user != null){
        HomePontoModel? _home = await _service.getHome(user);
        homeModel = _home;
        if(_home != null){
          print(_home.funcionario?.nome);
          await context.read<UserPontoManager>().updateUser(
              nome: _home.funcionario?.nome,
              cargo: _home.funcionario?.cargo,
              perm: _home.funcionario?.permitirMarcarPonto,
              offline: _home.funcionario?.permitirMarcarPontoOffline,
              local: _home.funcionario?.capturarGps
          );
          _pontoService.salvarNovoUsuario( user.toMap() );
          notifyListeners();
        }
      }
    } on Exception catch (e) {
      debugPrint('try erro getHome ' + e.toString());
      homeModel = null;
    }
  }

  signOut(){
    homeModel = null;
  }


}