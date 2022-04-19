import '../../../common/custom_snackbar.dart';
import '../../../common/load_screen.dart';
import '../../../helper/validators.dart';
import '../../../model/page_manager.dart';
import '../../../services/login/login_manager.dart';
import '../../../services/senha/senha_manager.dart';
import '../../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:provider/provider.dart';

class EsqueciSenhaScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  EsqueciSenhaScreen(this.scaffoldKey);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child:Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _menssagem(),
                SizedBox(height: 13,),

                textFormFieldEmail(context),

                SizedBox(height: 13,),
                _enviarSenha(context),
              ],
            )),
    );
  }

  Container _menssagem( ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text("Informe o seu e-mail para o envio de sua senha",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24, color: Colors.white,),
      ),
    );
  }

  //Enviar Senha
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
                style: TextStyle(fontSize: 20, color: Settings.corPribar),),
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
                style: TextStyle(fontSize: 20, color: Settings.corPribar),),
            ),
          ),
        )
    ]);
  }

  textFormFieldEmail(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: context.watch<LoginManager>().email,
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
            if(!emailValid(email!)){
              return 'E-mail inválido';
            }else{
              return null;
            }
          },
        ),
    );
  }

  _clickLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      carregar(context,);
      await context.read<SenhaManager>().sendPass(
          context.read<LoginManager>().email.text,
          onFail: (e) async {
            Navigator.pop(context);
            await WarningAlertBox(
                context: context,
                title: 'Falha',
                messageText: e,
                buttonText: 'ok'
            );
          },
          onSuccess: (e) async {
            Navigator.pop(context);
            context.read<PageManager>().setPage(0);
            await SuccessAlertBox(
                context: context,
                title: 'Sucesso',
                messageText: e,
                buttonText: 'ok'
            );
          }
      );
    }
  }
}
