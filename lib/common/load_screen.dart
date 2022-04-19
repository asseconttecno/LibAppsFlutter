import 'package:flutter/material.dart';

carregar(BuildContext context){
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return  Center(child: CircularProgressIndicator(backgroundColor: Colors.transparent,),
        );
      }
  );
}