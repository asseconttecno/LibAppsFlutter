import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';


import 'package:assecontservices/assecontservices.dart';



Future AlterarSenhaModal(BuildContext context){
  return CustomAlert.custom(
      context: context,
      titulo: 'Alterar Senha'.toUpperCase(),
      corpo: AlertSenha()
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

    return  Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                CustomText.text(
                "Deseja trocar a senha?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,),
                child: TextFormField(
                  controller: senhaAtual,
                  validator: (value) {
                    if (value == null || value == '') {
                      return "Digite sua senha";
                    }else if(value != Config.usenha){
                      return "Senha Inválida";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Senha Atual",
                    errorStyle: const TextStyle(color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),

                    suffixIcon: GestureDetector(
                      child: Icon(
                        !_showSenhaAtual
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: context.watch<Config>().darkTemas ? Colors.white : Colors.black,
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
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Nova Senha",
                    errorStyle: const TextStyle(color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    suffixIcon: GestureDetector(
                      child: Icon(
                        !_showSenhaNova
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: context.watch<Config>().darkTemas ? Colors.white : Colors.black,
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
                    backgroundColor: Config.corPri,
                  ),
                  child:   Center(
                    child: CustomText.text("ENVIAR",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  // onPressed: () {},
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      carregar(context);
                      bool result = await context.read<SenhaPontoManager>().alteracaoPass(
                          context, context.read<UserPontoManager>().usuario!,
                        senhaAtual.text, senhaNova.text,
                      );

                      if(result){
                        Config.usenha = senhaNova.text;
                        context.read<UserPontoManager>().senha.text = senhaNova.text;
                        context.read<UserPontoManager>().memorizar();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        CustomAlert.sucess(
                          context: context,
                          mensage: 'Senha Alterada!',
                        );
                      }else{
                        Navigator.pop(context);
                        CustomAlert.erro(
                          context: context,
                          mensage: 'Senha Alterada!\n',
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 15,)
            ],
          ),
        )
    );
  }
}

