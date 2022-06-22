import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_calendar_week/flutter_calendar_week.dart';


import '../../../common/common.dart';
import '../../../controllers/controllers.dart';
import '../../../config.dart';
import 'custom_menu_item.dart';



class CustomScaffold {

  static home({GlobalKey? keyListMenu, required List<CustomMenuItem> listMenu,
    required BuildContext context, required Widget appbar, required Widget body}){
    return custom(
      key: Config.scaffoldKey,
      body: body,
      height: 200,
      appbar: appbar,
      context: context,
      expanAppbar: Container(
        key: keyListMenu,
        margin: const EdgeInsets.only(top: 170),
        height: 115,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: listMenu,
        ),
      ),
    );
  }

  static calendario({GlobalKey<ScaffoldState>? key, required Function(DateTime) funcData,
    required List<DecorationItem> listdecoration, required String appTitle,
    required BuildContext context, required Widget body}){

    final CalendarWeekController _controller = CalendarWeekController();

    return custom(
      key: key,
      body: body,
      appTitle: appTitle,
      height: 110,
      appbar: CalendarWeek(
          controller: _controller,
          height: 50,
          showMonth: true,
          backgroundColor: Colors.transparent,
          minDate: context.watch<UserPontoManager>().usuario?.aponta?.datainicio,
          maxDate: context.watch<UserPontoManager>().usuario?.aponta?.datatermino,
          dateStyle: const TextStyle(color: Colors.white,),
          dayOfWeekStyle: TextStyle(color: Config.corPri),
          todayDateStyle: const TextStyle(color: Colors.white,),
          monthStyle: const TextStyle(color: Colors.white),
          pressedDateBackgroundColor: Colors.white30,
          pressedDateStyle: const TextStyle(color: Colors.white),
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
    required Widget appbar, required Widget body, Widget? expanAppbar, String? appTitle}){
    return Scaffold(
      key: key,
      appBar: appTitle == null ? null : AppBar(
        title: Text(appTitle),
        centerTitle: true,
        actions: [
          actions(context),
        ],
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      height: height, width: double.infinity,
                      decoration: BoxDecoration(
                          color: context.watch<Config>().darkTemas ?
                          Theme.of(context).primaryColor : Config.corPribar,
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
              body
            ],
          )
      ),
    );
  }
}