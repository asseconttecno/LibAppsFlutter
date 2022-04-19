import 'dart:async';
import 'dart:typed_data';

import '../../../common/actions/actions.dart';
import '../../../services/apontamento/apontamento_manager.dart';
import '../../../services/camera/camera_manager.dart';
import '../../../enums/bio_support_state.dart';
import '../../../services/login/login_manager.dart';
import '../../../ui/smartphone/camera/foto_screen.dart';
import '../../../services/home/home_manager.dart';
import '../../../services/registro/gps.dart';
import '../../../services/usuario/users_manager.dart';
import '../../../settintgs.dart';

import 'package:flutter_carousel_slider/carousel_slider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:provider/provider.dart';
import 'package:tutorial/tutorial.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/registro/registro_manager.dart';
import 'componentes/costom_menu_item.dart';
import 'componentes/custom_listTile.dart';
import 'componentes/load_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  List<TutorialItens> itens = [];
  final ScrollController scrollController = ScrollController();
  bool loadpage = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  final keyRegistro = GlobalKey();

  keyStatus() async {

    Future.delayed(Duration(microseconds: 200)).then((value) async {
      keyMenu.currentState?.showButtonMenu();
      Future.delayed(Duration(seconds: 1)).then((value) async {
        Tutorial.showTutorial(
            context, itens, (v)  {
              if(v == (Settings.isWin ? 3:  4) && (keyMenu.currentState?.mounted ?? false)){
                //keyMenu.currentState!.showButtonMenu();
                Navigator.pop(keyMenu.currentState!.context,);
              }else if(v == (Settings.isWin ? 5 : 6)){
                Settings().priacesso();
              }else if(v == (Settings.isWin ? 6 : 7)){
                _loginBiometria();
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
    context.read<HomeManager>().getHome();
    context.read<CameraManager>().getPhoto();
    context.read<ApontamentoManager>().getPeriodo();
    deleteHist();
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        loadpage = false;
      });
    });
    if(Settings.primeiroAcesso || !kReleaseMode){
      itens.addAll({
        TutorialItens(
            globalKey: keyMenu1,
            touchScreen: true,
            top: WidgetsBinding.instance?.window.padding.top,
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: Text(
                  "Nesse menu é possível alterar o período para consultas.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: EdgeInsets.all(5),
              color: Colors.black12,
              child: Text("Continuar",
                style: TextStyle(
                  color: Settings.corPri,
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
                child: Text(
                  "Nesse menu é possível alterar a senha do usuário.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: EdgeInsets.all(5),
              color: Colors.black12,
              child: Text("Continuar",
                style: TextStyle(
                  color: Settings.corPri,
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
                child: Text(
                  "Nesse menu é possível verificar versão do app, alterar modo escuro e autenticação.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: EdgeInsets.all(5),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Settings.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            shapeFocus: ShapeFocus.square),
        if(!Settings.isWin)
        TutorialItens(
            globalKey: keyMenu4,
            touchScreen: true,
            top: 120 + (WidgetsBinding.instance?.window.padding.top ?? 0),
            left: 10,
            right: 180,
            children: [
              Container(color: Colors.black54,
                child: Text(
                  "Nesse menu é possível avaliar o app na loja.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: EdgeInsets.all(5),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Settings.corPri,
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
                child: Text(
                  "Nesse menu é possível deslogar do usuário atual.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50,)
            ],
            widgetNext: Container(
              padding: EdgeInsets.all(5),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Settings.corPri,
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
                padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
              child: Center(
                child: Text(
                  "Lista de menu deslizável na horizontal.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 50,)
          ],
          widgetNext: Container(
              padding: EdgeInsets.all(5),
              //margin: EdgeInsets.only(right: 30),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Settings.corPri,
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
              padding: EdgeInsets.only(top: 20, bottom: 20,),
              child: Center(
                child: Text(
                  "Resumo dos resultados do período.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 30,)
          ],
          widgetNext: Container(
              padding: EdgeInsets.all(5), //margin: EdgeInsets.only(right: 30),
              color: Colors.black12,
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Settings.corPri,
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
              padding: EdgeInsets.only(top: 20, bottom: 20, right: 50),
                child: Center(
                  child: Text(
                  "Clicando em Registrar é possível realizar a marcação de ponto.",
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
          widgetNext: Container(
              padding: EdgeInsets.all(5), //margin: EdgeInsets.only(right: 30),
              color: Colors.black12,
              child: Text(
                "Sair",
                style: TextStyle(
                  color: Settings.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          shapeFocus: ShapeFocus.oval,
        ),
      });
      keyStatus();
    }else{
      _loginBiometria();
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

    return Consumer2<HomeManager, UserManager>(
          builder: (_,home, user,__){
            List<int>? img = context.watch<CameraManager>().img;

            return Scaffold(key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Meu Ponto',),
                centerTitle: true,
                actions: [
                  actions(context, aponta: true, keyMenu: keyMenu, key1: keyMenu1,
                      key2: keyMenu2, key3: keyMenu3, key4: keyMenu4, key5: keyMenu5),
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 80, color: Theme.of(context).scaffoldBackgroundColor))
                ),
                child: Stack(
                  children: [
                    Container(
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top:160+68.0),
                                    child: SingleChildScrollView(
                                      //controller: scrollController,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          //SizedBox(height: 160+65.0,),
                                          Container(
                                            height: 100,
                                            padding: EdgeInsets.all(10),
                                            child: CarouselSlider(
                                              children: [
                                                InkWell(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                                        image: DecorationImage(
                                                          image: AssetImage('assets/imagens/bompacredito.jpg'),
                                                          fit: BoxFit.fitWidth,
                                                        )
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      await launch('https://afiliado.bompracredito.com.br/?utm_source=cobranded&utm_medium=assecont');
                                                    }
                                                ),
                                                /*
                                                InkWell(
                                                    child: Image.asset('assets/imagens/assecont.png', fit: BoxFit.fitWidth,),
                                                    onTap: () async {
                                                      await launch('https://assecont.com.br');
                                                    }
                                                ),
                                                 */
                                              ],
                                              autoSliderDelay: Duration(seconds: 10),
                                              keepPage: false,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                              children:[
                                                SizedBox(width: 50,),
                                                Text('Resumo:',
                                                  style: TextStyle(
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize: 14 ,
                                                  ),
                                                ),
                                              ]
                                          ),
                                          SizedBox(width: 5,),
                                          Text(user.usuario?.aponta?.descricao ?? '',
                                            style: TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 14 ,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ]),
                          ),
                          user.usuario?.nome == null ?  SliverToBoxAdapter(
                              child: Container(key: keyResumo,
                                child: shimmerWidget(width, context),
                              )
                          ) : SliverToBoxAdapter(
                            child: Container(key: keyResumo,
                              height: 80.0 * (home.homeModel?.resultadoItemList?.length ?? 1),
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
                                          InfoAlertBox(
                                              context: context,
                                              title: 'Ops!',
                                              infoMessage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                                              buttonText: 'ok'
                                          );
                                        }
                                    );
                                  },
                                  itemCount: (home.homeModel?.resultadoItemList?.length ?? 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 160+65.0,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),

                    Column(
                      children: [
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                              color: context.watch<Settings>().darkTemas ?
                                Theme.of(context).primaryColor :
                                Settings.corPribar,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(45),
                                bottomLeft: Radius.circular(45),
                              )
                          ),
                          alignment: Alignment.topCenter,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: width * 0.6,
                                    padding: EdgeInsets.only(left: 15, right: 5),
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
                                              color: Settings.corPri
                                          ),
                                        ),
                                        Text(user.usuario?.cargo ?? '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Settings.corPri,
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
                                              Border.all(color: Settings.corPri, width: 2) :
                                              Border.all(color: Colors.white, width: 5),
                                              borderRadius: BorderRadius.circular(100),
                                              color: Settings.corPri,
                                              image: img != null ?
                                              DecorationImage(
                                                  image: MemoryImage(Uint8List.fromList(img)),
                                                  fit: BoxFit.fitWidth
                                              ): null
                                          ),child: img == null ?
                                        Icon(CupertinoIcons.person,
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
                        ),
                      ],
                    ),

                    //menu appbar
                    Container(
                      key: keyListMenu,
                      margin: EdgeInsets.only(top: 130),
                      height: 115,
                      alignment: Alignment.center,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          CustomMenuItem(
                            Icon(Icons.calendar_today, color: Colors.white, size: 40),
                            'Marcações',
                                () {
                                  Navigator.pushNamed(context, '/marcacoes');
                                },
                          ),

                          CustomMenuItem(
                            Icon(Icons.account_balance, color: Colors.white, size: 40,),
                            'Banco Horas',
                              () {
                                if(user.usuario?.master ?? false){
                                  Navigator.pushNamed(context, '/banco');
                                }else{
                                  InfoAlertBox(
                                      context: context,
                                      title: 'Ops!',
                                      infoMessage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                                      buttonText: 'ok'
                                  );
                                }
                              },
                          ),

                          CustomMenuItem(
                            Icon(Icons.question_answer, color: Colors.white, size: 40),
                              'Solicitações',
                              () {
                                if(user.usuario?.master ?? false){
                                  Navigator.pushNamed(context, '/solicitacoes');
                                }else{
                                  InfoAlertBox(
                                      context: context,
                                      title: 'Ops!',
                                      infoMessage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                                      buttonText: 'ok'
                                  );
                                }
                              },
                          ),

                          CustomMenuItem(
                            Icon(Icons.monetization_on_outlined, color: Colors.white, size: 40),
                              'Holerites',
                              () {
                                if(user.usuario?.master ?? false){
                                  Navigator.pushNamed(context, '/holerites');
                                }else{
                                  InfoAlertBox(
                                      context: context,
                                      title: 'Ops!',
                                      infoMessage: 'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                                      buttonText: 'ok'
                                  );
                                }
                              },
                          ),

                        ],
                      ),
                    ),
                  ],
                )
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                key: keyRegistro,
                backgroundColor: Settings.corPri,
                onPressed: () async {
                  print(user.usuario?.permitirMarcarPonto);
                  if(user.usuario?.permitirMarcarPonto ?? true){
                    if(context.read<UserManager>().usuario?.permitirLocalizacao ?? false){
                      context.read<Gps>().localizacao();
                    }
                    await Navigator.pushNamed(context, '/registro');
                    setState(() {});
                  }else{
                    InfoAlertBox(
                        context: context,
                        title: 'Atenção',
                        infoMessage: 'Você não tem permissão para marca o ponto!',
                        buttonText: 'ok'
                    );
                  }
                },
                label: Text('REGISTRAR', style: TextStyle(fontSize: 20, color: Colors.white),)
              ),
            );
      }
    );
  }

  _loginBiometria()  {
   if(Settings.bioState == BioSupportState.supported){
     context.read<LoginManager>().notfiBio(
       sucess: (){
         return showDialog(
             context: context,
             builder: (context){
               return Consumer<LoginManager>(
                 builder: (_,bio,__){
                   return AlertDialog(
                     title: Text("Gostaria de se logar com sua biometria?"),
                     titlePadding: EdgeInsets.only( top: 30, right: 10, left: 15 ),
                     titleTextStyle: TextStyle(fontSize: 14, color: context.watch<Settings>().darkTemas ? Colors.white : Colors.black),
                     buttonPadding: EdgeInsets.zero,
                     contentPadding: EdgeInsets.only(bottom: 0, right: 15, top: 15),
                     content: Column(mainAxisSize: MainAxisSize.min,
                         children: <Widget>[
                           Icon(Icons.fingerprint, size: 100, color: Colors.blueAccent,),
                           Row(mainAxisAlignment: MainAxisAlignment.end,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                               Checkbox(focusColor: Colors.blue,
                                   value: bio.perguntar,
                                   onChanged: ( valor){
                                     bio.perguntar = valor!;
                                   }
                               ),
                               Text("Nao Perguntar novamente", textAlign: TextAlign.left,
                                 style: TextStyle( fontSize: 14),
                               ),
                             ],),
                         ]),
                     actions: <Widget>[
                       TextButton(
                           onPressed: () {
                             bio.bio = false;
                             Navigator.pop(context);
                           },
                           child: Text("Não")
                       ),
                       TextButton(
                           onPressed: () {
                             bio.bio = true;
                             Navigator.pop(context);
                           },
                           child: Text("Sim")
                       ),
                     ],
                   );
                 },
               );
             }
         );
       },
     );
   }
  }

  customIcon(String desc){
    switch( desc ){
      case'Horas Extras' :
        icon = Transform.rotate(
          angle: 12.0,
          child: Icon(Icons.arrow_forward_outlined, size: 30,),
        );
        function = (){
          Navigator.pushNamed(context,'/marcacoes', arguments: 2);
        };
        break;
      case 'Atrasos' :
        icon = Transform.rotate(
          angle: 15.0,
          child: Icon(Icons.arrow_forward_outlined, size: 30),
        );
        function = (){
          Navigator.pushNamed(
              context,'/marcacoes', arguments: 1
          );
        };
        break;
      case 'Abonos' :
        icon = Icon(Icons.medical_services_outlined, size: 30);
        function = (){
          Navigator.pushNamed(
              context,'/marcacoes', arguments: 1
          );
        };
        break;
      case 'Saldo no Banco' :
        icon = Icon(Icons.account_balance, size: 30);
        function = (){
          Navigator.pushNamed(context,'/banco',);
        };
        break;
      case 'Falta' :
        icon = Icon(Icons.timer_off_outlined, size: 30);
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