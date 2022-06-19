import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:safe_device/safe_device.dart';
import 'package:trust_location/trust_location.dart';
import 'package:device_preview/device_preview.dart';


import 'controllers/controllers.dart';
import 'enums/enums.dart';
import 'helper/helper.dart';
import 'model/model.dart';
import 'settintgs.dart';

export 'model/model.dart';
export 'enums/enums.dart';
export 'controllers/controllers.dart';
export 'services/services.dart';
export 'common/common.dart';
export 'ui/ui.dart';
export 'helper/helper.dart';

class Assecontservices {

  static init({required SettingsModel settings, required List<SingleChildWidget> providers,
       required bool devicePreview, String? titulo, RouteFactory? rotas,  Widget? myApp}) async {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    Provider.debugCheckInvalidValueType = null;

    Settings.conf = settings;
    if(Settings.isIOS) {
      Settings.isJailBroken = await SafeDevice.isJailBroken;
    }else if(!Settings.isWin){
      Settings.isRealDevice = await SafeDevice.isRealDevice;
      Settings.canMockLocation = await TrustLocation.isMockLocation;
    }

    bool ponto = settings.nomeApp == VersaoApp.PontoApp || settings.nomeApp == VersaoApp.PontoTablet;

    List<SingleChildWidget> _providers = [
      ChangeNotifierProvider(
        lazy: false,
        create: (_)=> Settings(),
      ),
      if(settings.nomeApp != VersaoApp.AssewebApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> HoleriteManager(),
        ),
      if(settings.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> InformeManager(),
        ),
      if(settings.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> UserHoleriteManager(),
        ),
      if(settings.nomeApp == VersaoApp.HoleriteApp)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> PrimeiroAcessoHoleriteManager(),
        ),
      if(settings.nomeApp == VersaoApp.PontoTablet)
        ChangeNotifierProvider(
          lazy: true,
          create: (_)=> ConfigPontoManager(),
        ),
      if(settings.nomeApp == VersaoApp.PontoTablet)
        ChangeNotifierProvider(
          lazy: false,
          create: (_)=> EmpresaPontoManager(),
        ),
      if(settings.nomeApp == VersaoApp.PontoTablet)
        Provider(
          lazy: true,
          create: (_)=> UserPontoOffilineManager(),
        ),
      if(settings.nomeApp == VersaoApp.PontoTablet)
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

    _providers.addAll(providers);

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
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    if(!Settings.isWin){
      auth.isDeviceSupported().then((isSupported) {
            Settings.bioState = isSupported
                ? BioSupportState.supported
                : BioSupportState.unsupported;
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.titulo ?? '',
      debugShowCheckedModeBanner: false,
      theme: context.watch<Settings>().darkTemas ?
      ThemeData.dark().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Settings.corPri,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: ThemeData.dark().primaryColor,
          titleTextStyle: TextStyle(color: Settings.corPri,),
          toolbarTextStyle: TextStyle(color: Settings.corPri,fontSize: 18),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ) : ThemeData.light().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Settings.corPri,
        ),
        primaryColor: Settings.corPribar ,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(color: Settings.corPri,),
          toolbarTextStyle: TextStyle(color: Settings.corPri, fontSize: 18),
          elevation: 0,
          color: Settings.corPribar,
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