

import 'package:assecontservices/assecontservices.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../controller/tutor_controller.dart';
import 'custom_listTile.dart';
import 'custom_listTile_web.dart';
import 'load_widget.dart';

class ResiltatosView extends StatefulWidget {
  UsuarioPonto? usuario;
  HomePontoModel? homeModel;
  ScrollController? scrollController;

  ResiltatosView(this.usuario, this.homeModel, this.scrollController);

  @override
  State<ResiltatosView> createState() => _ResiltatosViewState();
}

class _ResiltatosViewState extends State<ResiltatosView> {
  Widget icon = Container();
  VoidCallback? function;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    dynamic data = DateFormat('EEEE d MMM y', 'pt_BR').format(DateTime.now());

    return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 80,
                color: Theme.of(context).scaffoldBackgroundColor))),
        child: widget.usuario == null
            ? Container(
          key: context.read<TutorController>().keyResumo,
          child: shimmerWidget(width, context),
        ) : Card(
          //color: Colors.white.withOpacity(0.95),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if(kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone)
                  Column(
                    children: [
                      CustomText.text(
                        context.watch<GetHora>().horarioAtual,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      CustomText.text(data
                          .toUpperCase()
                          .toString()
                          .replaceAll("-FEIRA", ""),
                          style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                    ],
                  ),
                  SizedBox(height: 10,),
                  //const SizedBox(height: 10,),
                  Row(children: [
                    const SizedBox(
                      width: 50,
                    ),
                    CustomText.text(
                      'Resumo:',
                      style: const TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ]),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText.text(
                    widget.usuario?.periodo?.descricao?.toUpperCase() ?? '',
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              ExpandedOrContainer(
                key: context.read<TutorController>().keyResumo,
                isContainer: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone,
                height: 230,
                //height: 80.0 * (home.homeModel?.resultadoItemList?.length ?? 1),
                child: ListView.builder(
                  controller: widget.scrollController,
                  scrollDirection: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? Axis.horizontal : Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    customIcon(widget.homeModel?.resultadosList![index].id);
                    return kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ?
                    CustomListTileWeb(
                        icon,
                        widget.homeModel?.resultadosList![index].titulo ?? '',
                        widget.homeModel?.resultadosList![index].valor ?? '',
                        (widget.usuario?.app ?? false) ? function
                            : () {
                          CustomAlert.info(
                            context: context,
                            mensage:
                            'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                          );
                        }
                    )
                        : CustomListTile(
                        icon,
                        widget.homeModel?.resultadosList![index].titulo ?? '',
                        widget.homeModel?.resultadosList![index].valor ?? '',
                        (widget.usuario?.app ?? false) ? function
                            : () {
                          CustomAlert.info(
                            context: context,
                            mensage:
                            'Você está utilizando a Versão free.\nContate seu gestor para contratar a versão máster!\n',
                          );
                        });
                  },
                  itemCount:
                  (widget.homeModel?.resultadosList?.length ?? 0),
                ),
              ),
            ],
          ),
        )
    );
  }


  customIcon(int? desc) {
    switch (desc) {
      case 2:
        icon = Transform.rotate(
          angle: 12.0,
          child: Icon(
            Icons.arrow_forward_outlined,
            size: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 60 : 30,
          ),
        );
        function = () {
          Navigator.pushNamed(context, '/marcacoes', arguments: 2);
        };
        break;
      case 3:
        icon = Transform.rotate(
          angle: 15.0,
          child: Icon(Icons.arrow_forward_outlined, size: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 60 : 30),
        );
        function = () {
          Navigator.pushNamed(context, '/marcacoes', arguments: 1);
        };
        break;
      case 4:
        icon = Icon(Icons.medical_services_outlined, size: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 60 : 30);
        function = () {
          Navigator.pushNamed(context, '/marcacoes', arguments: 3);
        };
        break;
      case 5:
        icon = Icon(Icons.account_balance, size: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 60 :  30);
        function = () {
          Navigator.pushNamed(
            context,
            '/banco',
          );
        };
        break;
      case 1:
        icon = Icon(Icons.timer_off_outlined,  size: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 60 : 30);
        function = () {
          Navigator.pushNamed(context, '/marcacoes', arguments: 4);
        };
        break;
      default:
        icon = Container();
        function = null;
        break;
    }
  }
}


