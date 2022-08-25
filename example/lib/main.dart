import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';


import '../route_generator.dart';
import 'controller/hora/gethora.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Assecontservices.init(
      config: ConfiguracoesModel(
          apiAsseweb: 'https://www.asseweb.com.br/ApiAsseweb',
          apiHolerite: 'https://www.asseweb.com.br/AssecontAPI',
          apiHoleriteEmail: 'https://www.asseweb.com.br/HoleriteApi',
          apiAsseponto: 'https://www.asseponto.com.br/asseponto.api.v5',
          apiEspelho: 'https://www.asseponto.com.br/ApiEspelho',

          androidAppId: 'com.assecont.AssepontoMobile',
          iosAppId: 'com.assecont.assepontoweb',
          iosAppIdNum: '1490469231',
          nomeApp: VersaoApp.PontoApp
      ),
      titulo: 'Asseponto App',
      rotas: RouteGenerator.generateRoute,
      providers: [
        ChangeNotifierProvider(
          create: (_)=> GetHora(),
        ),
      ]
  );
}