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
      if(context != null && user != null){
        HomePontoModel? _home = await _service.getHome(user);
        homeModel = _home;
        await context.read<UserPontoManager>().updateUser(
            nome: homeModel!.funcionario?.nome,
            cargo: homeModel!.funcionario?.cargo,
            perm: homeModel!.funcionario?.permitirMarcarPonto,
            offline: homeModel!.funcionario?.permitirMarcarPontoOffline,
            local: homeModel!.funcionario?.capturarGps
        );
        _pontoService.salvarNovoUsuario( user.toMap() );
        notifyListeners();
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