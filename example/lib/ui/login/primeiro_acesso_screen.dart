import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:brasil_fields/brasil_fields.dart';
import 'package:assecontservices/assecontservices.dart';


class PrimeiroAcessoScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  PrimeiroAcessoScreen(this.scaffoldKey);

  @override
  State<PrimeiroAcessoScreen> createState() => _PrimeiroAcessoScreenState();
}

class _PrimeiroAcessoScreenState extends State<PrimeiroAcessoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController cnpj = TextEditingController();
  final TextEditingController registro = TextEditingController();
  final focus = FocusNode();

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
                      keyboardType: TextInputType.number,
                      controller: cnpj,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        // obrigatório
                        FilteringTextInputFormatter.digitsOnly,
                        CnpjInputFormatter(),
                      ],
                      onFieldSubmitted: (v){
                        FocusScope.of(context).requestFocus(focus);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        errorStyle: TextStyle( color: Colors.red[100]),
                        hintText: "CNPJ",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 5,right: 10),
                          child:  Icon(
                            Icons.business,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      validator: (v){
                        if((v?.isEmpty ?? true)){
                          return 'Digite o CNPJ!';
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
                      controller: registro,
                      focusNode: focus,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        errorStyle: TextStyle( color: Colors.red[100]),
                        hintText: "Registro",
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
                        if(email?.isEmpty ?? true){
                          return 'Digite o seu numero de registro';
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
      child: Text("Informe o cnpj da sua empresa e seu numero de registro",
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
              _clickLogin(context);
            },
            child: Center(
              child: Text('AVANÇAR',
                style: TextStyle(fontSize: 20, color: Config.corPribar),),
            ),
          ),
        )
    ]);
  }

  _clickLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      carregar(context,);
      await context.read<PrimeiroAcessoHoleriteManager>().verificar(context,
        registro: registro.text,
        cnpj: cnpj.text,
      ).then((bool? v) {
        if (v != null) {
          Navigator.pop(context);
          if(v){
            context.read<PageManager>().setPage(4);
          }else{
            CustomAlert.info(
                context: context,
                mensage: 'Usuario já cadastrado no sistema!',
            );
          }
        }
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        if(error.toString() == 'Empresa não cadastrada!'){
           PrimeiroAcessoAlert(context);
        }else{
          CustomAlert.erro(
              context: context,
              mensage: error.toString(),
          );
        }
      });
    }
  }
}
