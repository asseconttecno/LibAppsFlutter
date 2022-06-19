import 'package:flutter/material.dart';


import '../../common/common.dart';
import '../../controllers/controllers.dart';


funcSair(BuildContext context){
  carregar(context);
  context.read<UserPontoManager>().signOut();
  context.read<CameraManager>().img = null;
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}