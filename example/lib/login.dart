


import 'package:flutter/material.dart';

class LoginTeste extends StatefulWidget {
  const LoginTeste({Key? key}) : super(key: key);

  @override
  State<LoginTeste> createState() => _LoginTesteState();
}

class _LoginTesteState extends State<LoginTeste> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Text('Login Teste'),
    );
  }
}
