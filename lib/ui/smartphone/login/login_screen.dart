import '../../../common/custom_snackbar.dart';
import '../../../helper/conn.dart';
import '../../../helper/validators.dart';
import '../../../services/camera/camera_manager.dart';
import '../../../services/login/login_manager.dart';
import '../../../services/usuario/users_manager.dart';
import '../../../settintgs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/page_manager.dart';

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
                    loadAcessar ? _clickAcesso(context.read<LoginManager>().email.text.trim())
                        : _clickLogin(context.read<LoginManager>().email.text.trim(),
                        context.read<LoginManager>().senha.text);
                  },
                  child: Center(
                    child: Text(loadAcessar ?  'ACESSAR' : 'LOGIN',
                      style: TextStyle(fontSize: 20, color: Settings.corPribar),),
                  ),
                ),
              ) : Center(
                child: CircularProgressIndicator(),
              ),

              SizedBox(
                height: 20,
              ),
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
            ]
        )
      ),
    );
  }

  Widget acessar(){
    return Form(key: _formKeyEmail,
      child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: context.watch<LoginManager>().email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 25,
                    ),
                    onPressed: (){
                  context.read<LoginManager>().email.clear();
                }),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                errorStyle: TextStyle( color: Colors.red[100]),
                hintText: "E-mail",
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
                if(!emailValid(email!)){
                  return 'E-mail inválido';
                }else{
                  return null;
                }
              },
            ),
          ),
    );
  }

  Widget loginSenha(){
    return Form(key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: context.watch<LoginManager>().email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 25,
                    ),
                    onPressed: (){
                      context.read<LoginManager>().email.clear();
                }),
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
                if(!emailValid(email!)){
                  return 'E-mail inválido';
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
              controller: context.watch<LoginManager>().senha,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 25,
                    ),
                    onPressed: (){
                      context.read<LoginManager>().senha.clear();
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
                  value: context.watch<LoginManager>().status,
                  onChanged: ( valor){
                    context.read<LoginManager>().status = valor!;
                  }
              ),
            )
          )
        ],
      ),
    );
  }

  _clickLogin(String email, String senha) {
    if(_formKey.currentState!.validate()) {
      context.read<LoginManager>().auth(email, senha, false, context,
            sucess: (){
              Settings.senha = senha;
              context.read<LoginManager>().memorizar();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            }, erro: (e, c){
              customSnackbar(e, c, widget.scaffoldKey);
            }
        );
    }
  }

  _clickAcesso(String email ) {
    if (_formKeyEmail.currentState!.validate()) {
      if(context.read<LoginManager>().bio){
        if(email == context.read<LoginManager>().uemail){
          context.read<LoginManager>().auth(email, context.read<LoginManager>().senha.text, true, context,
              sucess: (){
                Settings.senha = context.read<LoginManager>().senha.text;
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              }, erro: (e, c){
                setState(() {
                  loadAcessar = false;
                });
              }
          );
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