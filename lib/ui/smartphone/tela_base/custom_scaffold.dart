import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_calendar_week/flutter_calendar_week.dart';


import '../../../common/common.dart';
import '../../../controllers/controllers.dart';
import '../../../config.dart';
import 'custom_menu_item.dart';



class CustomScaffold {

  static home({GlobalKey? keyListMenu, required List<CustomMenuItem> listMenu, double? height, Widget? buttom,
    required BuildContext context, required Widget appbar, required Widget body, bool isListView = true}){

    double h = 180 + MediaQuery.of(context).padding.top;

    return custom(
      key: Config.scaffoldKey,
      body: body,
      height: height ?? h,
      appbar: appbar,
      context: context,
      buttom: buttom,
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
          backgroundColor: Colors.transparent,
          minDate: dataMin ?? DateTime(2020),
          maxDate: dataMax ?? DateTime(DateTime.now().year + 1),
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
    Widget? appbar, required Widget body, Widget? expanAppbar, String? appTitle, Widget? buttom}){

    return Scaffold(
      key: key,
      appBar: appTitle == null ? null : AppBar(
        title: CustomText.text(appTitle, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          actions(context),
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
}