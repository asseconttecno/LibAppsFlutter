import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';
import 'package:brasil_fields/brasil_fields.dart';


import '../../controllers/primeiro_acesso/primeiro_acesso_manager.dart';


class CadastroScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  CadastroScreen(this.scaffoldKey);

  @override
  State<CadastroScreen> createState() => _CadastroScreenScreenState();
}

class _CadastroScreenScreenState extends State<CadastroScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController cpf = TextEditingController();
  final TextEditingController senha = TextEditingController();
  final TextEditingController csenha = TextEditingController();
  final TextEditingController cel = TextEditingController();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

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

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      textInputAction: TextInputAction.next,
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
                      onFieldSubmitted: (v){
                        FocusScope.of(context).requestFocus(focus);
                      },
                      validator: (email){
                        if(!emailValid(email!)){
                          return 'Digite seu email!';
                        }else{
                          return null;
                        }
                      },

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: cpf,
                      focusNode: focus,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                      textInputAction: TextInputAction.next,
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
                            Icons.account_box_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (v){
                        FocusScope.of(context).requestFocus(focus1);
                      },
                      validator: (v){
                        if((v?.isEmpty ?? true)){
                          return 'Digite o CPF!';
                        }else{
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: cel,
                      focusNode: focus1,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        // obrigatório
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      onFieldSubmitted: (v){
                        FocusScope.of(context).requestFocus(focus2);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintStyle: TextStyle(color: Colors.white,),
                        errorStyle: TextStyle(color: Colors.red[100]),
                        hintText: "Celular",
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 5,right: 10),
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      controller: senha,
                      focusNode: focus2,
                      onFieldSubmitted: (v){
                        FocusScope.of(context).requestFocus(focus3);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintStyle: TextStyle(color: Colors.white,),
                        errorStyle: TextStyle(color: Colors.red[100]),
                        hintText: "Senha",
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 5,right: 10),
                          child: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      obscureText: true,
                      validator: (senha){
                        if(senha!.isEmpty || senha.length < 0){
                          return "Digite sua senha!";
                        }else{
                          return null;
                        }
                      },

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      focusNode: focus3,
                      controller: csenha,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintStyle: TextStyle(color: Colors.white,),
                        errorStyle: TextStyle(color: Colors.red[100]),
                        hintText: "Confirmar Senha",
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 5,right: 10),
                          child: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      obscureText: true,
                      validator: (s){
                        if(s!.isEmpty || s.length < 0){
                          return "Digite sua senha!";
                        }else if(s != senha.text){
                          return "Senhas nao conferem";
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
      child: Text("Informe seu dados",
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
              context.read<PageManager>().setPage(2);
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
              _clickLogin(context);
            },
            child: Center(
              child: Text('ENVIAR',
                style: TextStyle(fontSize: 20, color: Config.corPribar),),
            ),
          ),
        )
    ]);
  }

  _clickLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      carregar(context,);
      await context.read<PrimeiroAcessoManager>().cadastrar(context,
        email: email.text, cpf: cpf.text, senha: senha.text, cel: cel.text,
      ).then((bool? v) {
        if (v ?? false) {
          Navigator.pop(context);
          context.read<PageManager>().setPage(0);
          CustomAlert.sucess(
              context: context,
              mensage: 'Usuario cadastrado',
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
