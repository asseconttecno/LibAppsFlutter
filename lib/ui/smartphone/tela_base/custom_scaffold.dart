import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:responsive_framework/responsive_framework.dart';


import '../../../common/common.dart';
import '../../../controllers/controllers.dart';
import '../../../config.dart';
import 'custom_menu_item.dart';
import 'drawer_web.dart';


class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key, this.keyListMenu, required this.listMenu,
    this.height, required this.body, this.foto, this.dados, this.keyMenu, this.buttom,
    this.key1, this.key2, this.key3, this.key4, this.key5, required this.appTitle,
    this.nome, this.cargo, this.onAlter, this.isListView = true, this.onFoto = true,
  });

  final GlobalKey? keyListMenu;
  final List<CustomMenuItem> listMenu;
  final double? height;
  final Widget? buttom;
  final Widget body;
  final bool isListView;
  final String? foto;
  final Widget? dados;
  final GlobalKey? keyMenu;
  final GlobalKey? key1;
  final GlobalKey? key2;
  final GlobalKey? key3;
  final GlobalKey? key4;
  final GlobalKey? key5;
  final String appTitle;
  final String? nome;
  final String? cargo;
  final bool onFoto;
  final Function()? onAlter;


  @override
  Widget build(BuildContext context) {
    double h = 180 + MediaQuery.of(context).padding.top;

    return kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
        && !ResponsiveBreakpoints.of(context).isPhone
        ? HomeWebWidget(
        body: body,
        nome:nome ,
        cargo:cargo ,
        buttom: buttom,
        listMenus: listMenu,
        onAlter: onAlter,
        foto: onFoto ? Hero(
          tag: "foto",
          child: GestureDetector(
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => ImageHero(
                          foto == null ? null : base64Decode(foto!)
                      ))
              );
              //setState(() {});
            },
            child: Container(
              alignment: Alignment.topCenter,
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  border: foto != null
                      ? Border.all(
                      color: Config.corPri, width: 2)
                      : Border.all(
                      color: Colors.white, width: 5),
                  borderRadius: BorderRadius.circular(100),
                  color: Config.corPri,
                  image: foto != null
                      ? DecorationImage(
                      image: MemoryImage(base64Decode(foto!)),
                      fit: BoxFit.cover)
                      : null),
              child: foto == null ? const Icon(
                CupertinoIcons.person,
                color: Colors.white,
                size: 90,
              ) : null,
            ),
          ),
        ) : null,
        dados: dados,
        appTitle: appTitle
    ) : HomeIoWidget(
      key: Config.scaffoldKey,
      body: body,
      height: height ?? h,
      onAlter: onAlter,
      appbar: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 20,
                ),
                CustomText.text(appTitle,
                  style: const TextStyle(color: Config.corPri, fontSize: 18),
                ),
                actions(context,
                    aponta: true,
                    keyMenu: keyMenu,
                    key1: key1,
                    key2: key2,
                    key3: key3,
                    key4: key4,
                    key5: key5,
                    onAlter: onAlter
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: dados ??  Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText.text(nome,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,),
                        CustomText.text(cargo,
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                if(onFoto)
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Hero(
                      tag: "foto",
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ImageHero(
                                      foto == null ? null : base64Decode(foto!)
                                  ))
                          );
                          //setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: foto != null
                                  ? Border.all(
                                  color: Config.corPri, width: 2)
                                  : Border.all(
                                  color: Colors.white, width: 5),
                              borderRadius: BorderRadius.circular(100),
                              color: Config.corPri,
                              image: foto != null
                                  ? DecorationImage(
                                  image: MemoryImage(base64Decode(foto!)),
                                  fit: BoxFit.cover)
                                  : null),
                          child: foto == null ? const Icon(
                            CupertinoIcons.person,
                            color: Colors.white,
                            size: 90,
                          ) : null,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      buttom: buttom,
      home: true ,
      expanAppbar: Container(
        key: keyListMenu,
        margin: EdgeInsets.only(top: (height ?? h) - 30),
        height: 120,
        alignment: Alignment.center,
        child: isListView ?
        ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: listMenu,
        ) :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: listMenu,
        ),
      ),
    );
  }
}


class HomeCalendarioWidget extends StatefulWidget {
  const HomeCalendarioWidget({super.key, this.globalKey, required this.funcData,
    required this.controller, required this.body, required this.listdecoration,
    required this.appTitle, this.buttom, this.dataInit, this.dataMin, this.dataMax});

  final GlobalKey<ScaffoldState>? globalKey;
  final Function(DateTime) funcData;
  final CalendarWeekController controller;
  final Widget body;
  final List<DecorationItem> listdecoration;
  final String appTitle;
  final Widget? buttom;
  final DateTime? dataInit;
  final DateTime? dataMin;
  final DateTime? dataMax;

  @override
  State<HomeCalendarioWidget> createState() => _HomeCalendarioWidgetState();
}

class _HomeCalendarioWidgetState extends State<HomeCalendarioWidget> {

  @override
  void initState() {
    if(widget.dataInit != null){
      widget.controller.jumpToDate(widget.dataInit!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeIoWidget(
      key: widget.globalKey,
      body: widget.body,
      appTitle: widget.appTitle,
      height: 110,
      buttom: widget.buttom,
      appbar: CalendarWeek(
          controller: widget.controller,
          height: 100,
          showMonth: true,
          activeIcon: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
              && !ResponsiveBreakpoints.of(context).isPhone,
          backgroundColor: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
              && !ResponsiveBreakpoints.of(context).isPhone
              ? Config.corPribar : Colors.transparent,
          minDate: widget.dataMin ?? DateTime(2020),
          maxDate: widget.dataMax ?? DateTime(DateTime.now().year + 1),
          dateStyle: TextStyle(color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
              && !ResponsiveBreakpoints.of(context).isPhone ? Config.corPri : Colors.white,),
          dayOfWeekStyle: const TextStyle(color: Config.corPri),
          todayDateStyle: TextStyle(color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
              && !ResponsiveBreakpoints.of(context).isPhone ? Config.corPri : Colors.white,),
          monthStyle: const TextStyle(color:  Colors.white),
          pressedDateBackgroundColor: Colors.white30,
          pressedDateStyle: const TextStyle(color:  Colors.white),
          weekendsStyle: const TextStyle(color: Config.corPri),
          onDatePressed: widget.funcData,
          dayOfWeek: const [
            "Seg",
            "Tec",
            "Qua",
            "Qui",
            "Sex",
            "Sab",
            "Dom"
          ],
          month: const [
            "Janeiro",
            "Fevereiro",
            "Março",
            "Abril",
            "Maio",
            "Junho",
            "Julho",
            "Agosto",
            "Setembro",
            "Outubro",
            "Novembro",
            "Dezembro"
          ],
          decorations: widget.listdecoration
      ),
    );
  }
}



class HomeIoWidget extends StatelessWidget {
  const HomeIoWidget({super.key, this.globalKey, required this.height,
    this.onAlter, this.appbar, required this.body, this.expanAppbar,
    this.appTitle, this.buttom, this.conf = false, this.home = false, this.floatingActionButtonLocation,
  });
  final GlobalKey<ScaffoldState>? globalKey;
  final double height;
  final bool conf;
  final Function()? onAlter;
  final Widget? appbar;
  final Widget body;
  final bool home;
  final Widget? expanAppbar;
  final String? appTitle;
  final Widget? buttom;
  final FloatingActionButtonLocation? floatingActionButtonLocation;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: appTitle == null || kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
            && !ResponsiveBreakpoints.of(context).isPhone && appTitle != 'Configurações' ? null : AppBar(
          title: CustomText.text(appTitle, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
          centerTitle: true,
          actions: [
            actions(context, aponta: home, config: conf, onAlter: onAlter),
          ],
        ),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        height: height,
                        width: MediaQuery.of(context).size.width,
                        decoration: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                            && !ResponsiveBreakpoints.of(context).isPhone ? null
                            : BoxDecoration(
                            color: context.watch<Config>().darkTemas ?
                            Theme.of(context).appBarTheme.backgroundColor : Config.corPribar,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(45),
                              bottomLeft: Radius.circular(45),
                            )
                        ),
                        child: appbar
                    ),
                    if(expanAppbar != null)
                      expanAppbar!
                  ],
                ),
                Expanded(
                    child: body
                ),
              ],
            )
        ),
        floatingActionButtonLocation: buttom == null ? null
            : floatingActionButtonLocation ?? FloatingActionButtonLocation.centerFloat,
        floatingActionButton: buttom
    );
  }
}

class HomeWebWidget extends StatelessWidget {
  const HomeWebWidget({super.key, this.globalKey, this.buttom, required this.body, this.onAlter,
    required this.listMenus, this.foto, this.dados, required this.appTitle, this.nome,
    this.cargo, });
  final GlobalKey<ScaffoldState>? globalKey;
  final Widget? buttom;
  final Widget body;
  final List<Widget> listMenus;
  final Widget? foto;
  final Function()? onAlter;
  final Widget? dados;
  final String appTitle;
  final String? nome;
  final String? cargo;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            child: Container(
                width: 180, height: double.infinity,
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: DrawerWebView(listMenus, foto, appTitle )
            ),
          ),
          Expanded(
            child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: context.watch<Config>().darkTemas
                            ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5.5, 0), // Ajuste a sombra vertical aqui
                            blurRadius: 4, // Ajuste a intensidade da sombra aqui
                          ),
                        ],
                      ),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.text(nome,
                                    style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                                CustomText.text(cargo,
                                    style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
                              ],
                            ),

                            actions(context, aponta: true, onAlter: onAlter),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: body
                    ),
                  ],
                ),
                floatingActionButtonLocation: buttom == null ? null
                    :  FloatingActionButtonLocation.centerFloat,
                floatingActionButton: buttom
            ),
          ),
        ],
      ),
    );
  }
}
