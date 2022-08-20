import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';

import 'esqueci_senha_screen.dart';
import 'login_screen.dart';

class StartScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController pageController = PageController();


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(key: _scaffoldKey,
        body: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Config.corPribar2,   Config.corPribar]
              )
          ),
          child: ChangeNotifierProvider(
              create: (_) => PageManager(pageController),
              child: SingleChildScrollView(
                child: Container(
                  width: width,height: height,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                              //width: width,
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(
                                left: height * 0.050, right: height * 0.050, //top: height * 0.050
                              ),
                              child: Image.asset("assets/imagens/logo-assepontoweb.png",
                                fit: BoxFit.fitWidth,
                              )
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Container(
                            //height: height * 0.60,
                            alignment: Alignment.topCenter,
                            child: PageView(
                              controller: pageController,
                              physics:  const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                LoginScreen(_scaffoldKey),
                                EsqueciSenhaScreen(_scaffoldKey)
                            ]),
                          ),
                        ),
                      ]
                  ),
                ),
              ),
          ),
        ),
    );
  }

}
