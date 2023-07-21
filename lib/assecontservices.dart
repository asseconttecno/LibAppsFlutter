import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

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
export 'utils/utils.dart';
export 'package:provider/provider.dart';
export 'package:intl/intl.dart';
export 'package:flutter_calendar_week/flutter_calendar_week.dart';
export 'package:tutorial/tutorial.dart';

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

    bool ponto = Config.conf.nomeApp == VersaoApp.PontoApp || Config.conf.nomeApp == VersaoApp.PontoTablet;

    final BiometriaServices _bio = BiometriaServices();
    _bio.supportedBio();

    List<SingleChildWidget> _providers = [
      ChangeNotifierProvider(
        lazy: false,
        create: (_)=> Config(),
      ),
      if(Config.conf.nomeApp != VersaoApp.PontoTablet)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> BiometriaManager(),
        ),
      if(Config.conf.nomeApp != VersaoApp.AssewebApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> HoleriteManager(),
        ),
      if(Config.conf.nomeApp != VersaoApp.AssewebApp)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> UserHoleriteManager(),
        ),

      if(Config.conf.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> InformeManager(),
        ),

      if(Config.conf.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> PrimeiroAcessoHoleriteManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> SenhaHoleriteManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.PontoTablet)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> ConfigTabletManager(),
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
      ///--------------------------------------------------------------------///
      if(ponto)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> UserPontoManager(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          create: (_)=> ComprovanteManagger(),
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
          create: (_)=> CameraPontoManager(),
        ),
      if(ponto)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> SenhaPontoManager(),
        ),

      ///-----------asseweb--------------///
      if(Config.conf.nomeApp == VersaoApp.AssewebApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => HomeAssewebManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.AssewebApp)
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => UserAssewebManager(),
        ),
      if(Config.conf.nomeApp == VersaoApp.AssewebApp)
        Provider(
          lazy: false,
          create: (context) => SenhaAssewebManager(),
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
            builder: (context) => myApp ?? MyApp(titulo: titulo, rotas: rotas,), // Wrap your app
          ),
        )
    );
  }

}

class MyApp extends StatefulWidget {
  String? titulo;
  RouteFactory? rotas;
  MyApp({required this.titulo, required this.rotas});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.titulo ?? '',
      debugShowCheckedModeBanner: false,
      theme: context.watch<Config>().darkTemas ?
      ThemeData.dark(useMaterial3: true).copyWith(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Config.corPri,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: ThemeData.dark().primaryColor,
          titleTextStyle: const TextStyle(color: Config.corPri,),
          toolbarTextStyle: const TextStyle(color: Config.corPri,fontSize: 18),
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ) : ThemeData.light(useMaterial3: true).copyWith(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Config.corPri,
        ),
        primaryColor: Config.corPribar ,
        colorScheme: ThemeData(useMaterial3: true).colorScheme.copyWith(surfaceTint: Colors.white),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(color: Config.corPri,),
          toolbarTextStyle: TextStyle(color: Config.corPri, fontSize: 18),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          color: Config.corPribar,
        ),
      ),
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
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