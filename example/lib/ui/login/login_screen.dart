import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cpf_cnpj_validator/cpf_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(this.scaffoldKey,) ;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  bool load = false;
  bool loadAcessar = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              loadAcessar ? acessar() : loginSenha(),
              SizedBox(height: 20,),
              !load ? Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    loadAcessar ? _clickAcesso(context.read<UserHoleriteManager>().email.text.trim())
                        : _clickLogin(context.read<UserHoleriteManager>().email.text.trim(),
                        context.read<UserHoleriteManager>().senha.text);
                  },
                  child: Center(
                    child: Text(loadAcessar ?  'ACESSAR' : 'LOGIN',
                      style: TextStyle(fontSize: 20, color: Config.corPribar),),
                  ),
                ),
              ) : Center(
                child: CircularProgressIndicator(),
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.read<PageManager>().setPage(1);
                      },
                      child: Center(
                        child: Text('ESQUECEU A SENHA',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.read<PageManager>().setPage(2);
                      },
                      child: Center(
                        child: Text('ESQUECEU O EMAIL',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: TextButton(
                  onPressed: () {
                    context.read<PageManager>().setPage(3);
                  },
                  child: Center(
                    child: Text('PRIMEIRO ACESSO',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),

            ]
        )
      ),
    );
  }

  Widget acessar(){
    return Form(
      key: _formKeyEmail,
      child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: context.watch<UserHoleriteManager>().email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 25,
                    ),
                    onPressed: (){
                  context.read<UserHoleriteManager>().email.clear();
                }),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                errorStyle: TextStyle( color: Colors.red[100]),
                hintText: "E-mail/CPF",
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left:5,right: 10),
                  child:  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              validator: (email){
                if(email == null || email.isEmpty){
                  return 'Digite seu email ou cpf!';
                }else if(!emailValid(email)){
                  if(CPFValidator.isValid(email)){
                    return null;
                  }else{
                    return 'E-mail inválido';
                  }
                }else{
                  return null;
                }
              },
            ),
          ),
    );
  }

  Widget loginSenha(){
    final focus = FocusNode();

    return Form(key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: context.watch<UserHoleriteManager>().email,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 25,
                    ),
                    onPressed: (){
                      context.read<UserHoleriteManager>().email.clear();
                }),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                errorStyle: TextStyle( color: Colors.red[100]),
                hintText: "E-mail/CPF",
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
                if(email == null || email.isEmpty){
                  return 'Digite seu email ou cpf!';
                }else if(!emailValid(email)){
                  if(CPFValidator.isValid(email)){
                    return null;
                  }else{
                    return 'E-mail inválido';
                  }
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
              controller: context.watch<UserHoleriteManager>().senha,
              focusNode: focus,
              textInputAction: TextInputAction.done,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 25,
                    ),
                    onPressed: (){
                      context.read<UserHoleriteManager>().senha.clear();
                }),
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
            child: Theme(data: Theme.of(context).copyWith(disabledColor: Colors.white,
                unselectedWidgetColor: Colors.white),
              child: CheckboxListTile(
                  title: Text("Lembrar Senha", style: TextStyle(color: Colors.white),),
                  activeColor: Colors.redAccent,
                  value: context.watch<UserHoleriteManager>().status,
                  onChanged: ( valor){
                    context.read<UserHoleriteManager>().status = valor!;
                  }
              ),
            )
          )
        ],
      ),
    );
  }

  _clickLogin(String email, String senha) async {
    if(_formKey.currentState!.validate()) {
      bool? result = await context.read<UserHoleriteManager>().auth(context , email, senha, false,);

      if(result ?? false){
        Config.usenha = senha;
        context.read<UserHoleriteManager>().memorizar();
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }
  }

  _clickAcesso(String email ) async {
    if (_formKeyEmail.currentState!.validate()) {
      if(context.read<BiometriaManager>().bio){
        if(email == context.read<UserHoleriteManager>().uemail){
          bool? result = await context.read<UserHoleriteManager>().auth(
            context, email, context.read<UserHoleriteManager>().senha.text, true,);

          if(result ?? false){
            Config.usenha = context.read<UserHoleriteManager>().senha.text;
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }else{
            setState(() {
              loadAcessar = false;
            });
          }
        }else{
          setState(() {
            loadAcessar = false;
          });
        }
      }else{
        setState(() {
          loadAcessar = false;
        });
      }
    }else{
      setState(() {
        loadAcessar = false;
      });
    }
  }
}


//isabelaf@assecont.com.br