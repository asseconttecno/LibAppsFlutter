
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import '../../controller/gps.dart';
import '../../controller/home_controller.dart';
import '../../controller/tutor_controller.dart';

import '../banco_horas/banco_screen.dart';
import '../comprovantes/comprovantes_screen.dart';
import '../espelho/espelho_screen.dart';
import '../marcacoes/Marcacoes.dart';
import '../registro/screen_registro.dart';
import '../solicitacoes/solicitacoes_screen.dart';
import 'componentes/resultados.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final ScrollController scrollController = ScrollController();

  bool load = false;

  deleteHist() {
    RegistroManger().deleteHistorico();
  }

  @override
  void initState() {
    context.read<UserPontoManager>().getHome();
    context
        .read<ApontamentoManager>()
        .getPeriodo(context.read<UserPontoManager>().usuario);

    RegistroManger().enviarMarcacoes();
    deleteHist();
    if (!kIsWeb) {
      context.read<TutorController>().init(context);
    } else {
      BiometriaAlert(context);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      color: context.watch<Config>().darkTemas
          ? Theme.of(context).appBarTheme.backgroundColor
          : Config.corPribar,
      child: SafeArea(
        child: Consumer<UserPontoManager>(builder: (_, user, __) {
          return CustomScaffold.home(
            context: context,
            height: 170 + MediaQuery.of(context).padding.top,
            keyListMenu: context.read<TutorController>().keyListMenu,
            listMenu: [
              if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone)
                CustomMenuItem(
                  const Icon(Icons.fingerprint_sharp),
                  'Registrar',
                  () {
                    context.read<HomeController>().setPage(0);
                  },
                  isSelect: context.watch<HomeController>().page == 0,
                ),
              CustomMenuItem(
                const Icon(Icons.calendar_month_sharp),
                'Marcações',
                () {
                  if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone) context.read<HomeController>().setPage(1);
                  else Navigator.pushNamed(context, '/marcacoes');
                },
                isSelect: context.watch<HomeController>().page == 1
              ),
              if (!(user.usuario?.app ?? false))
                CustomMenuItem(
                  const Icon(Icons.receipt_rounded),
                  'Comprovantes',
                  () {
                    if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone) context.read<HomeController>().setPage(5);
                    else Navigator.pushNamed(context, '/comprovantes');
                  },
                  isSelect: context.watch<HomeController>().page == 5,
                ),
              CustomMenuItem(
                const Icon(
                  CupertinoIcons.doc_text_fill,
                ),
                'Espelho de Ponto',
                () {
                  if (user.usuario?.app ?? false) {
                    if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone) context.read<HomeController>().setPage(2);
                    else Navigator.pushNamed(context, '/espelho');
                  } else {
                    CustomAlert.info(
                      context: context,
                      mensage:
                          'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                    );
                  }
                },
                isSelect: context.watch<HomeController>().page == 2,
              ),
              CustomMenuItem(
                const Icon(
                  Icons.account_balance,
                ),
                'Banco Horas',
                () {
                  if (user.usuario?.app ?? false) {
                    if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone) context.read<HomeController>().setPage(3);
                    else Navigator.pushNamed(context, '/banco');
                  } else {
                    CustomAlert.info(
                      context: context,
                      mensage:
                          'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                    );
                  }
                },
                isSelect: context.watch<HomeController>().page == 3,
              ),
              CustomMenuItem(
                const Icon(Icons.question_answer),
                'Solicitações',
                () {
                  if (user.usuario?.app ?? false) {
                    if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone) context.read<HomeController>().setPage(4);
                    else Navigator.pushNamed(context, '/solicitacoes');
                  } else {
                    CustomAlert.info(
                      context: context,
                      mensage:
                          'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                    );
                  }
                },
                isSelect: context.watch<HomeController>().page == 4,
              ),
              if (user.usuario?.app ?? false)
                CustomMenuItem(
                  const Icon(Icons.receipt_rounded),
                  'Comprovantes',
                  () {
                    if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone) context.read<HomeController>().setPage(5);
                    else Navigator.pushNamed(context, '/comprovantes');
                  },
                  isSelect: context.watch<HomeController>().page == 5,
                ),

              CustomMenuItem(
                const Icon(Icons.monetization_on_outlined),
                'Holerites',
                () {
                  if (user.usuario?.app ?? false) {
                    if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone) context.read<HomeController>().setPage(6);
                    else Navigator.pushNamed(context, '/holerites');
                  } else {
                    CustomAlert.info(
                      context: context,
                      mensage:
                          'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                    );
                  }
                },
                isSelect: context.watch<HomeController>().page == 6,
              ),
            ],
            keyMenu: context.read<TutorController>().keyMenu,
            key1: context.read<TutorController>().keyMenu1,
            key2: context.read<TutorController>().keyMenu2,
            key3: context.read<TutorController>().keyMenu3,
            key4: context.read<TutorController>().keyMenu4,
            key5: context.read<TutorController>().keyMenu5,
            foto: user.usuario?.funcionario?.foto,
            nome: user.usuario?.funcionario?.nome,
            cargo: user.usuario?.funcionario?.cargo,
            dados: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.text(
                  'Olá, ' + (user.usuario?.funcionario?.nome ?? ''),
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Config.corPri),
                ),
                CustomText.text(
                  user.usuario?.funcionario?.cargo ?? '',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Config.corPri,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            appTitle: 'ASSEPONTO APP',
            body: PageView(
                controller: HomeController.pageController,
                pageSnapping: false,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ResiltatosView(user.usuario,user.homeModel, scrollController),
                  MarcacoesPage(),
                  EspelhoScreen(),
                  BancoHorasScreen(),
                  Solicitacoes(),
                  ComprovantesScreen(),
                  HoleriteScreen(),
                ]
            ),
            buttom: context.watch<HomeController>().page != 0 ? null : FloatingActionButton.extended(
                key: context.read<TutorController>().keyRegistro,
                backgroundColor: Config.corPri,
                onPressed: () async {
                  if(kIsWeb){
                    if(user.usuario?.funcionario?.permitirMarcarPontoWeb ?? true){
                      await context.read<RegistroManger>().postPontoMarcar(
                        context, context.read<UserPontoManager>().usuario!, null, null,
                      );
                    }else{
                      CustomAlert.info(
                        context: context,
                        mensage: 'Você não tem permissão para marca o ponto!',
                      );
                    }
                  }else{
                    if (user.usuario?.funcionario?.permitirMarcarPonto ?? true) {
                      if (context
                          .read<UserPontoManager>()
                          .usuario
                          ?.funcionario
                          ?.capturarGps ??
                          false) {
                        context.read<Gps>().localizacao();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistroScreen()),
                      );
                      //setState(() {});
                    } else {
                      CustomAlert.info(
                        context: context,
                        mensage: 'Você não tem permissão para marca o ponto!',
                      );
                    }
                  }
                },
                label: CustomText.text(
                  'REGISTRAR',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
            ),
          );
        }),
      ),
    );
  }


}
