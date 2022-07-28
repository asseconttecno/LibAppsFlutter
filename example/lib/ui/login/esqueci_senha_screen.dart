
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:assecontservices/assecontservices.dart';


class EsqueciSenhaScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  EsqueciSenhaScreen(this.scaffoldKey);

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isCpf = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          padding: EdgeInsets.all(25.0),
          child:Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _menssagem(),
                  SizedBox(height: 13,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Utilizar CPF para recuperar senha',
                          style: TextStyle(fontSize: 16,color: Colors.white),),
                        Switch(
                          activeColor: Colors.red,
                          hoverColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          value: isCpf, onChanged: (v){
                          setState(() {
                            isCpf = v;
                          });
                        }),
                      ],
                    ),
                  ),
                  isCpf ? Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: context.watch<UserHoleriteManager>().cpf,
                      inputFormatters: [
                        // obrigatório
                        FilteringTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        errorStyle: TextStyle( color: Colors.red[100]),
                        hintText: "CPF",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 5,right: 10),
                          child:  Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      validator: (cpf){
                        if(isCpf && ((cpf?.isEmpty ?? true) || (cpf?.length ?? 0) != 14)){
                          return 'Digite o CPF';
                        }else{
                          return null;
                        }
                      },
                    ),
                  ) : Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: context.watch<UserHoleriteManager>().email,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        errorStyle: TextStyle( color: Colors.red[100]),
                        hintText: "E-mail",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 5,right: 10),
                          child:  Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      validator: (email){
                        if(!isCpf && !emailValid(email!)){
                          return 'E-mail inválido';
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 13,),
                  _enviarSenha(context),
                  SizedBox(height: 13,),
                ],
              )),
      ),
    );
  }

  Container _menssagem( ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text("Informe o seu e-mail ou cpf para o envio de sua senha",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24, color: Colors.white,),
      ),
    );
  }

  Widget _enviarSenha(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: w * 0.4,
          //margin: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
          ),
          child: TextButton(
            onPressed: () {
              context.read<PageManager>().setPage(0);
            },
            child: Center(
              child: Text( 'VOLTAR',
                style: TextStyle(fontSize: 20, color: Config.corPribar),),
            ),
          ),
        ),
        Container(
          width: w * 0.4,
          //margin: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
          ),
          child: TextButton(
            onPressed: () {
              _cliqueEnviarSenha(context);
            },
            child: Center(
              child: Text('ENVIAR',
                style: TextStyle(fontSize: 20, color: Config.corPribar),),
            ),
          ),
        )
    ]);
  }


  _cliqueEnviarSenha(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      carregar(context,);
      await context.read<SenhaHoleriteManager>().sendPass(
        email: isCpf ? null : context.read<UserHoleriteManager>().email.text,
        cpf: isCpf ? context.read<UserHoleriteManager>().cpf.text :  null,
      ).then((String? v) {
        if(v != null){
          Navigator.pop(context);
          String e = context.read<SenhaHoleriteManager>().ofuscarEmail(v);
          CustomAlert.sucess(
              context: context,
              mensage: 'Enviamos para $e a nova senha de acesso',
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
  }
}


