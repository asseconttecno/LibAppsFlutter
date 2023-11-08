import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class FeriasPage extends StatefulWidget {
  @override
  _FeriasPageState createState() => _FeriasPageState();
}

class _FeriasPageState extends State<FeriasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.text("Férias"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText.text(
              'Aqui será a página para exibir as FÉRIAS',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
