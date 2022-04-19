import '../../common/load_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

funcSair(BuildContext context){
  carregar(context);
  context.read<UserManager>().signOut();
  context.read<CameraManager>().img = null;
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}