import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';


class LoginTeste extends StatefulWidget {
  const LoginTeste({Key? key}) : super(key: key);

  @override
  State<LoginTeste> createState() => _LoginTesteState();
}

class _LoginTesteState extends State<LoginTeste> {
  UserHoleriteService _service = UserHoleriteService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }


  login() async {
    List<UsuarioHolerite>? users = await _service.signInAuth(email: '42585327892', senha: '1983');
    print(users);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Text('Login Teste'),
    );
  }
}
