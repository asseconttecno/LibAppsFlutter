import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:assecontservices/assecontservices.dart';
import 'package:tutorial/tutorial.dart';


import '../../controller/home/home_manager.dart';
import '../camera/foto_screen.dart';
import '../registro/screen_registro.dart';
import 'componentes/custom_listTile.dart';
import 'componentes/load_widget.dart';



class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<PopupMenuButtonState<int>> keyMenu = GlobalKey();
  final GlobalKey keyMenu1 = GlobalKey();
  final keyMenu2 = GlobalKey();
  final keyMenu3 = GlobalKey();
  final keyMenu4 = GlobalKey();
  final keyMenu5 = GlobalKey();
  final keyResumo = GlobalKey();
  final keyListMenu = GlobalKey();
  final keyRegistro = GlobalKey();

  List<TutorialItens> itens = [];
  bool loadpage = true;
  Widget icon = Container();
  VoidCallback? function;
  bool load = false;


  keyStatus() async {

    Future.delayed(const Duration(microseconds: 200)).then((value) async {
      keyMenu.currentState?.showButtonMenu();
      Future.delayed(const Duration(seconds: 1)).then((value) async {
        Tutorial.showTutorial(
            context, itens, (v)  {
              if(v == (Config.isWin ? 3:  4) && (keyMenu.currentState?.mounted ?? false)){
                //keyMenu.currentState!.showButtonMenu();
                Navigator.pop(keyMenu.currentState!.context,);
              }else if(v == (Config.isWin ? 5 : 6)){
                Config().priacesso();
              }else if(v == (Config.isWin ? 6 : 7)){
                BiometriaAlert(context);
              }
            }
        );
      });
    });
  }

  deleteHist(){
    RegistroManger().deleteHistorico();
  }

  @override
  void initState() {
    context.read<ApontamentoManager>().getPeriodo(context.read<UserPontoManager>().usuario);
    context.read<HomeManager>().getHome();
    context.read<CameraPontoManager>().getPhoto(context.read<UserPontoManager>().usuario!);

    deleteHist();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        loadpage = false;
      });
    });
    if(Config.primeiroAcesso || !kReleaseMode){
      itens.addAll({
        TutorialItens(
            globalKey: keyMenu1,
            touchScreen: true,
            top: WidgetsBinding.instance?.window.padding.top,
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: const Text(
                  "Nesse menu é possível alterar o período para consultas.",
                  style: const TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.black12,
              child: Text("Continuar",
                style: TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            shapeFocus: ShapeFocus.square
        ),
        TutorialItens(
            globalKey: keyMenu2,
            touchScreen: true,
            top: 30 + (WidgetsBinding.instance?.window.padding.top ?? 0),
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: const Text(
                  "Nesse menu é possível alterar a senha do usuário.",
                  style: const TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.black12,
              child: Text("Continuar",
                style: TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            shapeFocus: ShapeFocus.square),
        TutorialItens(
            globalKey: keyMenu3,
            touchScreen: true,
            top: 60 + (WidgetsBinding.instance?.window.padding.top ?? 0) ,
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: const Text(
                  "Nesse menu é possível verificar versão do app, alterar modo escuro e autenticação.",
                  style: const TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            shapeFocus: ShapeFocus.square),
        if(!Config.isWin)
        TutorialItens(
            globalKey: keyMenu4,
            touchScreen: true,
            top: 120 + (WidgetsBinding.instance?.window.padding.top ?? 0),
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: const Text(
                  "Nesse menu é possível avaliar o app na loja.",
                  style: const TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            shapeFocus: ShapeFocus.square),
        TutorialItens(
            globalKey: keyMenu5,
            touchScreen: true,
            top: 160 + (WidgetsBinding.instance?.window.padding.top ?? 0),
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: const Text(
                  "Nesse menu é possível deslogar do usuário atual.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            shapeFocus: ShapeFocus.square),
        TutorialItens(
          globalKey: keyListMenu,
          touchScreen: true,
          bottom: 100,
          right: 0, left: 0,
          children: [
            Container(color: Colors.black54,
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
              child: const Center(
                child: Text(
                  "Lista de menu deslizável na horizontal.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 50,)
          ],
          widgetNext: Container(
              padding: const EdgeInsets.all(5),
              //margin: EdgeInsets.only(right: 30),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          shapeFocus: ShapeFocus.square,
        ),
        TutorialItens(
          globalKey: keyResumo,
          touchScreen: true,
          top: 300,
          right: 0, left: 0,
          children: [
            Container(color: Colors.black54,
              padding: const EdgeInsets.only(top: 20, bottom: 20,),
              child: const Center(
                child: Text(
                  "Resumo dos resultados do período.",
                  style: const TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30,)
          ],
          widgetNext: Container(
              padding: const EdgeInsets.all(5), //margin: EdgeInsets.only(right: 30),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          shapeFocus: ShapeFocus.square,
        ),
        TutorialItens(
          globalKey: keyRegistro,
          touchScreen: true,
          bottom: 220,
          right: 20, left: 20,

          children: [
            Container(color: Colors.black54,
              padding: const EdgeInsets.only(top: 20, bottom: 20, right: 50),
                child: const Center(
                  child: Text(
                  "Clicando em Registrar é possível realizar a marcação de ponto.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20,)
          ],
          widgetNext: Container(
              padding: const EdgeInsets.all(5), //margin: EdgeInsets.only(right: 30),
              color: Colors.black12,
              child: Text(
                "Sair",
                style: TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          shapeFocus: ShapeFocus.oval,
        ),
      });
      keyStatus();
    }else{
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
    double width = MediaQuery.of(context).size.width;

    return Consumer2<HomeManager, UserPontoManager>(
          builder: (_,home, user,__){
            List<int>? img = context.watch<CameraPontoManager>().img;

            return CustomScaffold.home(
              context: context,
              height: 170 + MediaQuery.of(context).padding.top,
              keyListMenu: keyListMenu,
              listMenu: [
                CustomMenuItem(
                  const Icon(Icons.calendar_today, color: Colors.white, size: 40),
                  'Marcações',
                      () {
                    Navigator.pushNamed(context, '/marcacoes');
                  },
                ),
                CustomMenuItem(
                  const Icon(Icons.receipt_rounded, color: Colors.white, size: 40,),
                  'Espelho de Ponto',
                      () {
                    if(user.usuario?.master ?? false){
                      Navigator.pushNamed(context, '/espelho');
                    }else{
                      CustomAlert.info(
                        context: context,
                        mensage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                      );
                    }
                  },
                ),
                CustomMenuItem(
                  const Icon(Icons.account_balance, color: Colors.white, size: 40,),
                  'Banco Horas',
                      () {
                    if(user.usuario?.master ?? false){
                      Navigator.pushNamed(context, '/banco');
                    }else{
                      CustomAlert.info(
                        context: context,
                        mensage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                      );
                    }
                  },
                ),

                CustomMenuItem(
                  const Icon(Icons.question_answer, color: Colors.white, size: 40),
                  'Solicitações',
                      () {
                    if(user.usuario?.master ?? false){
                      Navigator.pushNamed(context, '/solicitacoes');
                    }else{
                      CustomAlert.info(
                        context: context,
                        mensage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                      );
                    }
                  },
                ),

                CustomMenuItem(
                  const Icon(Icons.monetization_on_outlined, color: Colors.white, size: 40),
                  'Holerites',
                      () {
                    if(user.usuario?.master ?? false){
                      Navigator.pushNamed(context, '/holerites');
                    }else{
                      CustomAlert.info(
                        context: context,
                        mensage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                      );
                    }
                  },
                ),
              ],
              appbar: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: width * 0.6,
                        padding: const EdgeInsets.only(left: 15, right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Olá, ' + (user.usuario?.nome ?? ''),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Config.corPri
                              ),
                            ),
                            Text(user.usuario?.cargo ?? '',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                color: Config.corPri,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Hero(tag: "foto",
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ImageHero(img == null ? null :
                                  Uint8List.fromList(img)) ) );
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: 115,
                              width: 115,
                              decoration: BoxDecoration(
                                  border: img != null ?
                                  Border.all(color: Config.corPri, width: 2) :
                                  Border.all(color: Colors.white, width: 5),
                                  borderRadius: BorderRadius.circular(100),
                                  color: Config.corPri,
                                  image: img != null ?
                                  DecorationImage(
                                      image: MemoryImage(Uint8List.fromList(img)),
                                      fit: BoxFit.fitWidth
                                  ): null
                              ),child: img == null ?
                            const Icon(CupertinoIcons.person,
                              color: Colors.white,
                              size: 105,) : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 80, color: Theme.of(context).scaffoldBackgroundColor))
                ),
                child: user.usuario?.nome == null ?
                  Container(
                    key: keyResumo,
                    child: shimmerWidget(width, context),
                  ) :  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //const SizedBox(height: 10,),
                          Row(
                              children: const [
                                SizedBox(width: 50,),
                                Text('Resumo:',
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 14 ,
                                  ),
                                ),
                              ]
                          ),
                          const SizedBox(width: 5,),
                          Text(user.usuario?.aponta?.descricao ?? '',
                            style: const TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 14 ,
                            ),
                          ),
                        ],
                      ),

                      Expanded(
                        key: keyResumo,
                        //height: 80.0 * (home.homeModel?.resultadoItemList?.length ?? 1),
                        child: ListView.builder(
                          controller: scrollController,
                          itemBuilder:   (BuildContext context, int index) {
                            customIcon(home.homeModel?.resultadoItemList![index].descricao ?? '');
                            return CustomListTile(
                                icon,
                                home.homeModel?.resultadoItemList![index].descricao ?? '',
                                home.homeModel?.resultadoItemList![index].valor ?? '',
                                (user.usuario?.master ?? false) ? function :
                                    () {
                                  CustomAlert.info(
                                    context: context,
                                    mensage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                                  );
                                }
                            );
                          },
                          itemCount: (home.homeModel?.resultadoItemList?.length ?? 0),
                        ),
                      ),
                    ],
                )
              ),

              buttom: FloatingActionButton.extended(
                key: keyRegistro,
                backgroundColor: Config.corPri,
                onPressed: () {
                  if(user.usuario?.permitirMarcarPonto ?? true){
                    if(context.read<UserPontoManager>().usuario?.permitirLocalizacao ?? false){
                      context.read<Gps>().localizacao();
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  RegistroScreen()),
                    );
                    //setState(() {});
                  }else{
                    CustomAlert.info(
                        context: context,
                        mensage: 'Você não tem permissão para marca o ponto!',
                    );
                  }
                },
                label: const Text('REGISTRAR', style: TextStyle(fontSize: 20, color: Colors.white),)
              ),
            );
      }
    );
  }

  customIcon(String desc){
    switch( desc ){
      case'Horas Extras' :
        icon = Transform.rotate(
          angle: 12.0,
          child: const Icon(Icons.arrow_forward_outlined, size: 30,),
        );
        function = (){
          Navigator.pushNamed(context,'/marcacoes', arguments: 2);
        };
        break;
      case 'Atrasos' :
        icon = Transform.rotate(
          angle: 15.0,
          child: const Icon(Icons.arrow_forward_outlined, size: 30),
        );
        function = (){
          Navigator.pushNamed(
              context,'/marcacoes', arguments: 1
          );
        };
        break;
      case 'Abonos' :
        icon = const Icon(Icons.medical_services_outlined, size: 30);
        function = (){
          Navigator.pushNamed(
              context,'/marcacoes', arguments: 1
          );
        };
        break;
      case 'Saldo no Banco' :
        icon = const Icon(Icons.account_balance, size: 30);
        function = (){
          Navigator.pushNamed(context,'/banco',);
        };
        break;
      case 'Falta' :
        icon = const Icon(Icons.timer_off_outlined, size: 30);
        function = (){
          Navigator.pushNamed(
              context,'/marcacoes', arguments: 1
          );
        };
        break;
      default :
        icon = Container();
        function = null;
        break;
    }
  }
}