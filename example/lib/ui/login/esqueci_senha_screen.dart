import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:assecontservices/assecontservices.dart';


class EsqueciSenhaScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  EsqueciSenhaScreen(this.scaffoldKey);

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child:Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _menssagem(),
                const SizedBox(height: 13,),

                textFormFieldEmail(context),

                const SizedBox(height: 13,),
                _enviarSenha(context),
              ],
            )),
    );
  }

  Container _menssagem( ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: const Text("Informe o seu e-mail para o envio de sua senha",
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
          decoration: const BoxDecoration(
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
          decoration: const BoxDecoration(
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

  textFormFieldEmail(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: context.watch<UserPontoManager>().email,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            errorStyle: TextStyle( color: Colors.red[100]),
            hintText: "E-mail",
            prefixIcon: const Padding(
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
      bool result = await context.read<SenhaPontoManager>().sendPass(
          context,
          context.read<UserPontoManager>().email.text,
      );
      if(result){
        Navigator.pop(context);
        context.read<PageManager>().setPage(0);
        await CustomAlert.sucess(
          context: context,
          mensage: 'Nova senha enviada para seu email!\n',
        );
      }else{
        Navigator.pop(context);
        await CustomAlert.erro(
          context: context,
          mensage: 'Não foi possivel enviar sua senha, tente novamente!',
        );
      }
    }
  }
}
