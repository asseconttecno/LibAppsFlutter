import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';


import '../route_generator.dart';
import 'controller/gps.dart';
import 'controller/home_controller.dart';
import 'controller/tutor_controller.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Assecontservices.init(
      config: ConfiguracoesModel(
          apiAsseweb: 'https://www.asseweb.com.br/ApiAsseweb',
          apiHolerite: 'https://www.asseweb.com.br/AssecontAPI',
          apiHoleriteEmail: 'https://www.asseweb.com.br/HoleriteApi',
          apiAsseponto: 'https://www.asseponto.com.br/asseponto.api.v5',
          apiEspelho: 'https://www.asseponto.com.br/ApiEspelho',
          apiAssepontoNova: 'https://www.asseponto.com.br/ApiAsseponto',
          androidAppId: 'com.assecont.AssepontoMobile',
          iosAppId: 'com.assecont.assepontoweb',
          iosAppIdNum: '1490469231',
          nomeApp: VersaoApp.PontoApp
      ),
      titulo: 'Asseponto App',
      rotas: RouteGenerator.generateRoute,
      providers: [

        ChangeNotifierProvider(
          create: (_)=> Gps(),
        ),
        ChangeNotifierProvider(
          create: (_)=> HomeController(),
        ),
        Provider(
          create: (_)=> TutorController(),
        ),
      ]
  );
}