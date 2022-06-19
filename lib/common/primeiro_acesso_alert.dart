import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

PrimeiroAcessoAlert(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          content: Container(
            child: Container(
              //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min ,
                children: [
                  Row(
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
                        child: Text('CNPJ NÃO CADASTRADO',
                          style: TextStyle( fontWeight: FontWeight.w600,fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10),
                    child: Text('Entre em contato com nosso comercial para acesso!',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 15,),

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
                              children: [
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
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        );
      }
  );
}
