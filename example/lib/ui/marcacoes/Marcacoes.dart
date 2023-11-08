import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:assecontservices/assecontservices.dart';

import '../../controller/home_controller.dart';
import 'detelhes_marcacao.dart';

class MarcacoesPage extends StatefulWidget {
  int? filtro;
  MarcacoesPage({this.filtro});

  @override
  _MarcacoesState createState() => _MarcacoesState();
}

class _MarcacoesState extends State<MarcacoesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  final CalendarWeekController _controller = CalendarWeekController();


  @override
  void initState() {
    if(kIsWeb) widget.filtro = context.read<HomeController>().filtro;
    context.read<MarcacoesManager>().getEspelho(filtro: widget.filtro);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MarcacoesManager>(
        builder: (_, marcacao, __){

          return CustomScaffold.calendario(
              key: _scaffoldKey,
              context: context,
              appTitle:'Marcações',
              funcData: (DateTime datetime) {
                marcacao.data = datetime;
              },
              listdecoration: marcacao.listdecoration,
              controller: _controller,
              dataInit: marcacao.data,
              dataMin: context.read<UserPontoManager>().usuario?.periodo?.dataInicial,
              dataMax: context.read<UserPontoManager>().usuario?.periodo?.dataFinal,
              body: Center(
                  child: !connectionStatus.hasConnection ?   CustomText.text('Verifique sua Conexão com Internet') :
                  FutureBuilder<Marcacao?>(
                    future: marcacao.getMarcacaoDia(),
                    builder: (context, snapshot){
                      Widget resultado;
                      switch( snapshot.connectionState ){
                        case ConnectionState.none :
                        case ConnectionState.waiting :
                          resultado = const CircularProgressIndicator();
                          break;
                        case ConnectionState.active :
                        case ConnectionState.done :
                          if( snapshot.hasError ){
                            resultado = GestureDetector(
                              child: Icon(Icons.autorenew_outlined,
                                color: Config.corPri, size: 70,),
                              onTap: (){
                                setState(() {});
                              }
                            );
                          }else {
                            resultado = DetalhesMarcacao(snapshot.data, marcacao.data);
                          }
                          break;
                      }
                      return resultado;
                    },
                  )
              )
          );
        }
    );
  }
}
