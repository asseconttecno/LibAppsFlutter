import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import 'common.dart';

Future PrimeiroAcessoAlert(BuildContext context, {bool isCnpj = false}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          content: Container(
            //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min ,
              children: [
                const SizedBox(height: 10,),
                isCnpj ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Color(0xFFFF9800),
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: CustomText.text('CNPJ NÃO CADASTRADO',
                        style: TextStyle( fontWeight: FontWeight.w600,fontSize: 18),
                      ),
                    ),
                  ],
                ) :  Flexible(
                    child: CustomText.text('PRIMEIRO ACESSO',
                    style: TextStyle( fontWeight: FontWeight.w600,fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:10),
                  child: CustomText.text('Solicite para seu RH entrar em contato com Assecont!',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15,),

                if(!Config.isIOS)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Icon(CupertinoIcons.phone_down_circle_fill, color: Colors.green, size: 60,),
                              CustomText.text('11 21738888', textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11),),
                            ],
                          ),
                        ),
                        onTap: (){
                          launch('https://web.whatsapp.com/send?phone=551121738888&text=Ol%C3%A1%2C%20quero%20ser%20cliente%20da%20assecont');
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            children: [
                              Icon(CupertinoIcons.mail_solid, color: Colors.red, size: 60,),
                              CustomText.text('suporte@assecont.com.br', textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10),),
                            ],
                          ),
                        ),
                        onTap: (){
                          launch('mailto:suporte@assecont.com.br');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ),
        );
      }
  );
}
