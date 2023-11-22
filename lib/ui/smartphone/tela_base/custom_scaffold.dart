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



class CustomScaffold {

  static home({GlobalKey? keyListMenu, required List<CustomMenuItem> listMenu, double? height, Widget? buttom,
    required BuildContext context,required Widget body, bool isListView = true, String? foto, Widget? dados,
    GlobalKey? keyMenu, GlobalKey? key1, GlobalKey? key2,  GlobalKey? key3, GlobalKey? key4,  GlobalKey? key5,
    required String appTitle,String? nome, String? cargo}){

    double h = 180 + MediaQuery.of(context).padding.top;

    return kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone
      ? homeWeb(
        context: context,
        body: body,
        nome:nome ,
        cargo:cargo ,
        buttom: buttom,
        listMenus: listMenu,
        foto: Hero(
          tag: "foto",
          child: GestureDetector(
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => ImageHero(
                          foto == null ? null : base64Decode(foto)
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
                      image: MemoryImage(base64Decode(foto)),
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
        dados: dados,
        appTitle: appTitle

    ) : custom(
      key: Config.scaffoldKey,
      body: body,
      height: height ?? h,
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
                    key5: key5),
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
                    child: dados ?? Container(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Hero(
                    tag: "foto",
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ImageHero(
                                    foto == null ? null : base64Decode(foto)
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
                                image: MemoryImage(base64Decode(foto)),
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
      context: context,
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            children: listMenu,
          ) :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: listMenu,
          ),
      ),
    );
  }

  static calendario({GlobalKey<ScaffoldState>? key, required Function(DateTime) funcData,
    required CalendarWeekController controller, required Widget body,
    required List<DecorationItem> listdecoration, required String appTitle, Widget? buttom,
    required BuildContext context,  DateTime? dataInit, DateTime? dataMin, DateTime? dataMax}){

    if(dataInit != null){
      controller.jumpToDate(dataInit);
    }

    return custom(
      key: key,
      body: body,
      appTitle: appTitle,
      height: 110,
      buttom: buttom,
      appbar: CalendarWeek(
          controller: controller,
          height: 100,
          showMonth: true,
          activeIcon: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone,
          backgroundColor: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone
              ? Config.corPribar : Colors.transparent,
          minDate: dataMin ?? DateTime(2020),
          maxDate: dataMax ?? DateTime(DateTime.now().year + 1),
          dateStyle: TextStyle(color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? Config.corPri : Colors.white,),
          dayOfWeekStyle: TextStyle(color: Config.corPri),
          todayDateStyle: TextStyle(color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? Config.corPri : Colors.white,),
          monthStyle: TextStyle(color:  Colors.white),
          pressedDateBackgroundColor: Colors.white30,
          pressedDateStyle: const TextStyle(color:  Colors.white),
          weekendsStyle: TextStyle(color: Config.corPri),
          onDatePressed: funcData,
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
          decorations: listdecoration
      ),
      context: context,
    );
  }

  static custom({GlobalKey<ScaffoldState>? key, required BuildContext context, required double height,
    Widget? appbar, required Widget body, bool home = false, Widget? expanAppbar, String? appTitle, Widget? buttom}){

    return Scaffold(
      key: key,
      appBar: appTitle == null || kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
          && !ResponsiveBreakpoints.of(context).isPhone && appTitle != 'Configurações' ? null : AppBar(
        title: CustomText.text(appTitle, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          actions(context, aponta: home),
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
                      decoration: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? null : BoxDecoration(
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
                    expanAppbar
                ],
              ),
              Expanded(
                  child: body
              ),
            ],
          )
      ),
      floatingActionButtonLocation: buttom == null ? null : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buttom
    );
  }


  static homeWeb({GlobalKey<ScaffoldState>? key, required BuildContext context, Widget? buttom,
    required Widget body, required List<Widget> listMenus, required Widget foto,
    Widget? dados, required String appTitle,required String? nome,required String? cargo, }){


    return Scaffold(
      key: key,
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
                                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                              CustomText.text(cargo,
                                  style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
                            ],
                          ),

                          actions(context, aponta: true),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: body
                  ),
                ],
              ),
              floatingActionButtonLocation: buttom == null ? null : FloatingActionButtonLocation.centerFloat,
              floatingActionButton: buttom
            ),
          ),
        ],
      ),

    );
  }
}