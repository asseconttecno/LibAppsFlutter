import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  children: const [
                    Icon(
                      Icons.warning_rounded,
                      color: Color(0xFFFF9800),
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text('CNPJ NÃO CADASTRADO',
                        style: TextStyle( fontWeight: FontWeight.w600,fontSize: 18),
                      ),
                    ),
                  ],
                ) : const Flexible(
                    child: Text('PRIMEIRO ACESSO',
                    style: TextStyle( fontWeight: FontWeight.w600,fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal:10),
                  child: Text('Entre em contato com Assecont!',
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
                            children: const [
                              Icon(CupertinoIcons.phone_down_circle_fill, color: Colors.green, size: 60,),
                              Text('11 21738888', textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11),),
                            ],
                          ),
                        ),
                        onTap: (){
                          launch('https://web.whatsapp.com/send?phone=551121738863&text=Quero%20contratar%20holerite%20eletr%C3%B4nico');
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            children: const [
                              Icon(CupertinoIcons.mail_solid, color: Colors.red, size: 60,),
                              Text('comercial@assecont.com.br', textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10),),
                            ],
                          ),
                        ),
                        onTap: (){
                          launch('mailto:comercial@assecont.com.br');
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
