import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:tutorial/tutorial.dart';
import 'package:assecontservices/assecontservices.dart';


import '../alter_user/alterar_user.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  List<TutorialItens> itens = [];
  final ScrollController scrollController = ScrollController();
  bool loadpage = true;

  Widget icon = Container();
  VoidCallback? function;
  bool load = false;
  final GlobalKey<PopupMenuButtonState<int>> keyMenu = GlobalKey();
  final GlobalKey keyMenu1 = GlobalKey();
  final keyMenu2 = GlobalKey();
  final keyMenu3 = GlobalKey();
  final keyMenu4 = GlobalKey();
  final keyMenu5 = GlobalKey();
  final keyResumo = GlobalKey();
  final keyListMenu = GlobalKey();

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
                initial();
              }
            }
        );
      });
    });
  }


  initial() {
    BiometriaAlert(context);
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if((context.read<UserHoleriteManager>().listuser?.length ?? 0) > 1){
        AlterUser(context);
      }
    });
  }

  @override
  void initState() {
    context.read<HoleriteManager>().competencias(context.read<UserHoleriteManager>().user);

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
                  "Nesse menu é possível alterar o usuario",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
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
            top: WidgetsBinding.instance?.window.padding.top,
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: const Text(
                  "Nesse menu é possível alterar a senha do usuario",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
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
            globalKey: keyMenu3,
            touchScreen: true,
            top: 30 + (WidgetsBinding.instance?.window.padding.top ?? 0),
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: const Text(
                  "Nesse menu é possível verificar versão do app, alterar modo escuro e autenticação.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
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
        if(!Config.isWin)
        TutorialItens(
            globalKey: keyMenu4,
            touchScreen: true,
            top: 60 + (WidgetsBinding.instance?.window.padding.top ?? 0) ,
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: const Text(
                  "Nesse menu é possível avaliar o app na loja.",
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
            globalKey: keyMenu5,
            touchScreen: true,
            top: 120 + (WidgetsBinding.instance?.window.padding.top ?? 0),
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
                  "Visualização do ultimo holerite disponivel",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30,)
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
          shapeFocus: ShapeFocus.square,
        ),
      });
      keyStatus();
    }else{
      initial();
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

    return Consumer<UserHoleriteManager>(
          builder: (_,user,__){
            return CustomScaffold.home(
              context: context, isListView: false,
              height: 170 + MediaQuery.of(context).padding.top,
              keyListMenu: keyListMenu,
              appbar: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 20,),
                        Text('Holerite Eletronico', style: TextStyle(color: Config.corPri,fontSize: 18),),
                        actions(context, aponta: true, keyMenu: keyMenu, key1: keyMenu1,
                          key2: keyMenu2, key3: keyMenu3, key4: keyMenu4, key5: keyMenu5),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width - 40,
                          padding: const EdgeInsets.only(left: 15, right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Olá, ' + (user.user?.nome ?? ''),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                    color: Config.corPri
                                ),
                              ),
                              const SizedBox(height: 12,),
                              Text(user.user?.empresa ?? '',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Config.corPri,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8,),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Registro: ' + (user.user?.registro ?? ''),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Config.corPri,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text('Celular: ' + (user.user?.ddd ?? '') + (user.user?.celular ?? ''),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Config.corPri,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              listMenu: [
                CustomMenuItem(
                  const Icon(Icons.monetization_on_outlined, color: Colors.white, size: 40),
                  'Holerites',
                      () {
                    Navigator.pushNamed(context, '/holerites');
                  },
                ),
                CustomMenuItem(
                  const Icon(Icons.receipt_long, color: Colors.white, size: 40),
                  'Informe Rendimento',
                      () {
                    Navigator.pushNamed(context, '/infomes');
                  },
                ),
              ],
              body: Container(
                constraints: const BoxConstraints.expand(),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text('Ultimo Holerite: ' +
                            (context.watch<HoleriteManager>().listcompetencias.isNotEmpty ?
                            context.read<HoleriteManager>().listcompetencias.first.descricao! : ''),
                          style: const TextStyle(
                            fontSize: 14 ,
                          ),
                        ),
                      ]
                    ),

                    Expanded(
                      key: keyResumo,
                      child: LayoutBuilder(
                        builder: (context, constrans) {
                          return DetalhesHoleritePDF(constrans);
                        }
                      ),
                    ),

                  ],
                )
              ),
            );
      }
    );
  }
}