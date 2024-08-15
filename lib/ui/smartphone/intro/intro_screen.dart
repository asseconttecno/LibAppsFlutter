import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../config.dart';
import '../../../controllers/controllers.dart';


class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), (){
      if(mounted){
        final UpdateAppManager service = UpdateAppManager();
        try {
          service.checkVersion(context);
        }  catch (e) {
          // TODO
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Config.corPribar2,   Config.corPribar]
          )
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
              child: Image.asset('assets/imagens/LOGO_ASSECONT.png',
                  fit: BoxFit.fitWidth,  package: 'assecontservices'),
            ),
            const SizedBox(
                width: 50,
                child: LinearProgressIndicator(minHeight: 10, backgroundColor: Colors.transparent,)
            )
          ],
        ),
      ),
    );
  }
}
