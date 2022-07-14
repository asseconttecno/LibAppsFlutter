import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'package:assecontservices/assecontservices.dart';

import '../../controllers/senha/senha_manager.dart';

Future AlterarSenhaModal(BuildContext context) async {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController senhaAtual = TextEditingController();
  final TextEditingController senhaNova = TextEditingController();


  return await CustomAlert.custom(
      context: context,
      titulo: 'Alterar Senha',
      corpo: Consumer<SenhaManager>(
        builder: (context, senha, __) {
          return Container(
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
                          }else if(value != Config.senha){
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
                              !senha.showSenhaAtual
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: context.watch<Config>().darkTemas ? Colors.white : Colors.black,
                            ),
                            onTap: () {
                              senha.showSenhaAtual = !senha.showSenhaAtual;
                            },
                          ),
                        ),
                        obscureText: senha.showSenhaAtual,

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
                              !senha.showSenhaNova
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: context.watch<Config>().darkTemas ? Colors.white : Colors.black,
                            ),
                            onTap: () {
                              senha.showSenhaNova = !senha.showSenhaNova;
                            },
                          ),
                        ),
                        obscureText: senha.showSenhaNova,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Config.corPri,
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
                            await context.read<SenhaManager>().alteracaoPass(context,
                              senha: senhaAtual.text, senhaNova: senhaNova.text,).then((value) {
                              if(value != null){
                                Navigator.pop(context);
                                Navigator.pop(context);
                                CustomAlert.sucess(
                                  context: context,
                                  mensage: 'Senha Alterada!',
                                );
                              }
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              CustomAlert.erro(
                                context: context,
                                mensage: error.toString(),
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
          );
        }
      )
  );
}