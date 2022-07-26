import 'package:flutter/material.dart';


import '../../common/common.dart';
import '../../config.dart';
import '../../controllers/controllers.dart';
import '../../enums/enums.dart';


funcSair(BuildContext context){
  carregar(context);

  if(Config.conf.nomeApp == VersaoApp.HoleriteApp) {
    context.read<UserHoleriteManager>().signOut();
  } else if(Config.conf.nomeApp == VersaoApp.PontoApp) {
    context.read<UserPontoManager>().signOut();
    context.read<CameraPontoManager>().img = null;
  }

  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}