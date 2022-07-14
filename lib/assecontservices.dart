import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safe_device/safe_device.dart';
import 'package:trust_location/trust_location.dart';
import 'package:device_preview/device_preview.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'controllers/controllers.dart';
import 'services/services.dart';
import 'enums/enums.dart';
import 'helper/helper.dart';
import 'model/model.dart';
import 'config.dart';

export 'model/model.dart';
export 'enums/enums.dart';
export 'controllers/controllers.dart';
export 'services/services.dart';
export 'common/common.dart';
export 'ui/ui.dart';
export 'helper/helper.dart';
export 'config.dart';


class Assecontservices {

  static init({required ConfiguracoesModel config, required RouteFactory rotas,
      List<SingleChildWidget>? providers, bool devicePreview = false, String? titulo, Widget? myApp}) async {
    
    HttpOverrides.global = MyHttpOverrides();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    Provider.debugCheckInvalidValueType = null;

    Config.conf = config;
    final packageInfo = await PackageInfo.fromPlatform();
    Config.versao = packageInfo.version;
    if(Config.isIOS) {
      Config.isJailBroken = await SafeDevice.isJailBroken;
    }else if(!Config.isWin){
      Config.isRealDevice = await SafeDevice.isRealDevice;
      Config.canMockLocation = await TrustLocation.isMockLocation;
    }

    if (Config.conf.nomeApp == VersaoApp.PontoApp && defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }

    bool ponto = Config.conf.nomeApp == VersaoApp.PontoApp || Config.conf.nomeApp == VersaoApp.PontoTablet;

    List<SingleChildWidget> _providers = [
      ChangeNotifierProvider(
        lazy: false,
        create: (_)=> Config(),
      ),
      if(Config.conf.nomeApp != VersaoApp.AssewebApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> HoleriteManager(),
        ),
      if(Config.conf.nomeApp != VersaoApp.PontoTablet)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> BiometriaManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> InformeManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> UserHoleriteManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> PrimeiroAcessoHoleriteManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.PontoTablet)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> ConfigPontoManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.PontoTablet)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> EmpresaPontoManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.PontoTablet)
        Provider(
          lazy: true,
          create: (_)=> UserPontoOffilineManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.PontoTablet)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> HistoricoManager(),
        ),
      ///-------------------------///
      if(ponto)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> UserPontoManager(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> Gps(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> BancoHorasManager(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> MemorandosManager(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          //lazy: true,
          create: (_)=> EspelhoManager(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> MarcacoesManager(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> ApontamentoManager(),
        ),
      if(ponto)
        Provider(
          lazy: true,
          create: (_)=> RegistroManger(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> CameraManager(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> SenhaPontoManager(),
        ),

    ];

    if(providers != null){
      _providers.addAll(providers);
    }

    runApp(
        MultiProvider(
          providers: _providers,
          child: DevicePreview(
            enabled: devicePreview, //!kReleaseMode,
            builder: (context) => myApp ?? App(titulo: titulo, rotas: rotas,), // Wrap your app
          ),
        )
    );
  }

}

class App extends StatefulWidget {
  String? titulo;
  RouteFactory? rotas;
  App({required this.titulo, required this.rotas});


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<App> {
  BiometriaServices _bio = BiometriaServices();

  @override
  void initState() {
    super.initState();
    _bio.supportedBio();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.titulo ?? '',
      debugShowCheckedModeBanner: false,
      theme: context.watch<Config>().darkTemas ?
      ThemeData.dark().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Config.corPri,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: ThemeData.dark().primaryColor,
          titleTextStyle: TextStyle(color: Config.corPri,),
          toolbarTextStyle: TextStyle(color: Config.corPri,fontSize: 18),
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ) : ThemeData.light().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Config.corPri,
        ),
        primaryColor: Config.corPribar ,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(color: Config.corPri,),
          toolbarTextStyle: TextStyle(color: Config.corPri, fontSize: 18),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          color: Config.corPribar,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      initialRoute: '/',
      onGenerateRoute: widget.rotas,
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}