import 'package:flutter/material.dart';

carregar(BuildContext context){
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return  const Center(child: CircularProgressIndicator(backgroundColor: Colors.transparent,),
        );
      }
  );
}