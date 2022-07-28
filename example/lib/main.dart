import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';


import 'route_generator.dart';

//42585327892 1983


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Assecontservices.init(
      config: ConfiguracoesModel(
          apiAsseweb: 'https://www.asseweb.com.br/ApiAsseweb',
          apiHolerite: 'https://www.asseweb.com.br/AssecontAPI',
          apiHoleriteEmail: 'https://www.asseweb.com.br/HoleriteApi',
          apiAsseponto: 'https://www.asseponto.com.br/asseponto.api.v5',
          apiEspelho: 'https://www.asseponto.com.br/ApiEspelho',

          androidAppId: 'com.assecont.holerite',
          iosAppId: 'com.assecont.holerite',
          iosAppIdNum: '1601264668',
          nomeApp: VersaoApp.HoleriteApp
      ),
      titulo: 'Assecont Holerite',
      rotas: RouteGenerator.generateRoute,
      devicePreview: false,
      providers: [
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> InformeManager(),
        ),
      ]
  );
}