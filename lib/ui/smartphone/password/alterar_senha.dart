import '../../../common/load_screen.dart';
import '../../../services/login/login_manager.dart';
import '../../../services/senha/senha_manager.dart';
import '../../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'dart:ui';
import 'package:provider/provider.dart';

Future<Widget?> AlterarSenhaModal(BuildContext context){
  return showDialog<Widget>(
      context: context,
      builder: (context) {
        return AlertSenha();
    }
  );
}

class AlertSenha extends StatefulWidget {

  @override
  _AlertSenhaState createState() => _AlertSenhaState();
}

class _AlertSenhaState extends State<AlertSenha> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController senhaAtual = TextEditingController();
  final TextEditingController senhaNova = TextEditingController();
  bool _showSenhaAtual = true;
  bool _showSenhaNova = true;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
        title: Center(child: Text('Alterar Senha'.toUpperCase(),
          textAlign: TextAlign.center,
        )),
        titlePadding: EdgeInsets.only(top: 30, left: 10, right: 10),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            color: context.watch<Settings>().darkTemas ?
            Colors.white : Colors.black),
        contentPadding: EdgeInsets.all(width * 0.03),
        content: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Deseja trocar a senha?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 12,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,),
                    child: TextFormField(
                        controller: senhaAtual,
                        validator: (value) {
                          if (value == null || value == '') {
                            return "Digite sua senha";
                          }else if(value != Settings.senha){
                            return "Senha Inválida";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Senha Atual",
                          errorStyle: TextStyle(color: Colors.red),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),

                          suffixIcon: GestureDetector(
                            child: Icon(
                              !_showSenhaAtual
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: context.watch<Settings>().darkTemas ? Colors.white : Colors.black,
                            ),
                            onTap: () {
                              setState(() {
                                _showSenhaAtual = !_showSenhaAtual;
                              });
                            },
                          ),
                        ),
                        obscureText: _showSenhaAtual,

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: TextFormField(
                      controller: senhaNova,
                      validator: (value) {
                        if (value == null || value == '') {
                          return "Digite sua nova senha";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Nova Senha",
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            !_showSenhaNova
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: context.watch<Settings>().darkTemas ? Colors.white : Colors.black,
                          ),
                          onTap: () {
                            setState(() {
                              _showSenhaNova = !_showSenhaNova;
                            });
                          },
                        ),
                      ),
                      obscureText: _showSenhaNova,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Settings.corPri,
                      ),
                      child: Center(
                        child: Text("ENVIAR",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      // onPressed: () {},
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          carregar(context);
                          await context.read<SenhaManager>().alteracaoPass(
                              senhaAtual.text, senhaNova.text,
                              onFail: (e){
                                Navigator.pop(context);
                                WarningAlertBox(
                                    context: context,
                                    title: 'Falha',
                                    messageText: e,
                                    buttonText: 'ok'
                                );
                              },
                              onSuccess: (){
                                Settings.senha = senhaNova.text;
                                context.read<LoginManager>().senha.text = senhaNova.text;
                                context.read<LoginManager>().memorizar();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                SuccessAlertBox(
                                    context: context,
                                    title: 'Sucesso',
                                    messageText: 'Senha Alterada!',
                                    buttonText: 'ok'
                                );
                              }
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}

