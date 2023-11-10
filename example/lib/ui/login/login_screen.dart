import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen(
    this.scaffoldKey,
  );

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
    loadAcessar = !kIsWeb;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                loadAcessar ? acessar() : loginSenha(),
                const SizedBox(
                  height: 20,
                ),
                !load
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                        ),
                        child: TextButton(
                          onPressed: () {
                            loadAcessar
                                ? _clickAcesso(context
                                    .read<UserPontoManager>()
                                    .email
                                    .text
                                    .trim())
                                : _clickLogin(
                                    context.read<UserPontoManager>().email.text.trim(),
                                    context.read<UserPontoManager>().senha.text);
                          },
                          child: Center(
                            child: CustomText.text(
                              loadAcessar ? 'ACESSAR' : 'LOGIN',
                              style: TextStyle(
                                  fontSize: 20, color: Config.corPribar),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      context.read<PageManager>().setPage(1);
                    },
                    child:   Center(
                      child: CustomText.text(
                        'ESQUECEU A SENHA',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w900,
                          fontSize: 12
                        ),
                      ),
                    ),
                  ),
                ),
                if(!Config.isIOS)
                  Container(
                    alignment: Alignment.centerRight,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        PrimeiroAcessoAlert(context);
                      },
                      child:   Center(
                        child: CustomText.text(
                          'PRIMEIRO ACESSO',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w900,
                            fontSize: 12
                          ),
                        ),
                      ),
                    ),
                  ),
              ])),
    );
  }

  Widget acessar() {
    return Form(
      key: _formKeyEmail,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: context.watch<UserPontoManager>().email,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white54,
                  size: 25,
                ),
                onPressed: () {
                  context.read<UserPontoManager>().email.clear();
                }),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            errorStyle: TextStyle(color: Colors.red[100]),
            hintText: "E-mail",
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 5, right: 10),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          validator: (email) {
            if (!emailValid(email!)) {
              return 'E-mail inválido';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget loginSenha() {
    final focus = FocusNode();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: context.watch<UserPontoManager>().email,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
                errorStyle: TextStyle(color: Colors.red[100]),
                hintText: "E-mail",
                suffix: GestureDetector(
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 25,
                    ),
                    onTap: () {
                      context.read<UserPontoManager>().email.clear();
                    }),

                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 5, right: 10),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              onSaved: (t){
                FocusScope.of(context).requestFocus(focus);
              },
              validator: (email) {
                if (!emailValid(email!)) {
                  return 'E-mail inválido';
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: context.watch<UserPontoManager>().senha,
              style: const TextStyle(color: Colors.white),
              focusNode: focus,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 25,
                    ),
                    onTap: () {
                      context.read<UserPontoManager>().senha.clear();
                    }),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
                errorStyle: TextStyle(color: Colors.red[100]),
                hintText: "Senha",
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 5, right: 10),
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              obscureText: true,
              onSaved: (value){
                _clickLogin(
                    context.read<UserPontoManager>().email.text.trim(),
                    context.read<UserPontoManager>().senha.text);
              },
              validator: (senha) {
                if (senha!.isEmpty || senha.length < 0) {
                  return "Digite sua senha!";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
              child: Theme(
            data: Theme.of(context).copyWith(
                disabledColor: Colors.white,
                unselectedWidgetColor: Colors.white),
            child: CheckboxListTile(
                title:   CustomText.text(
                  "Manter-se Logado",
                  style: TextStyle(color: Colors.white),
                ),
                activeColor: Colors.redAccent,
                value: context.watch<UserPontoManager>().status,
                onChanged: (valor) {
                  context.read<UserPontoManager>().status = valor!;
                }),
          ))
        ],
      ),
    );
  }

  _clickLogin(String email, String senha) async {
    if (_formKey.currentState!.validate()) {
      bool? result = await context.read<UserPontoManager>().auth(context, email, senha, false);

      if(result ?? false){
        Config.usenha = context.read<UserPontoManager>().senha.text;
        context.read<UserPontoManager>().memorizar();

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }
  }

  _clickAcesso(String email) async {
    if (_formKeyEmail.currentState!.validate()) {
      if (context.read<BiometriaManager>().bio) {
        if (email == context.read<UserPontoManager>().uemail) {
          bool? result = await context.read<UserPontoManager>().auth(context,
            email, context.read<UserPontoManager>().senha.text, true,
          ).onError((error, stackTrace) {
            setState(() {
              loadAcessar = false;
            });
          });

          if(result ?? false){
            Config.usenha = context.read<UserPontoManager>().senha.text;
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }else{
            setState(() {
              loadAcessar = false;
            });
          }
        } else {
          setState(() {
            loadAcessar = false;
          });
        }
      } else {
        setState(() {
          loadAcessar = false;
        });
      }
    } else {
      setState(() {
        loadAcessar = false;
      });
    }
  }
}

//isabelaf@assecont.com.br
