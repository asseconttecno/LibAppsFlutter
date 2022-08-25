import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:assecontservices/assecontservices.dart';

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
  List<DecorationItem> listdecoration = [];
  final CalendarWeekController _controller = CalendarWeekController();


  @override
  void initState() {
    context.read<MarcacoesManager>().getEspelho(context.read<UserPontoManager>().usuario);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MarcacoesManager>(
        builder: (_, marcacao, __){
          //if(!start){
          marcacao.listamarcacao.map((element) {
            if(((element.resultado?.atrasosmin ?? 0) > 0 || (element.resultado?.faltasDias ?? 0) > 0)
                && (element.resultado?.extrasmin ?? 0)> 0){
              listdecoration.add(
                  DecorationItem(
                      decoration: Icon(Icons.circle, color: Config.corPri,),
                      date: element.datahora
                  )
              );
            }else if((element.resultado?.atrasosmin ?? 0) > 0 || (element.resultado?.faltasDias ?? 0) > 0){
              listdecoration.add(
                  DecorationItem(
                      decoration: const Icon(Icons.circle, color: Colors.red,),
                      date: element.datahora
                  )
              );

            }else if((element.resultado?.extrasmin ?? 0) > 0){
              listdecoration.add(
                  DecorationItem(
                      decoration: const Icon(Icons.circle, color: Colors.green,),
                      date: element.datahora
                  )
              );
            }else if((element.resultado?.abonosmin ?? 0) > 0){
              listdecoration.add(
                  DecorationItem(
                      decoration: const Icon(Icons.circle, color: Colors.white,),
                      date: element.datahora
                  )
              );
            }
          }).toList();
          //start = true;
          //}

          return CustomScaffold.calendario(
              key: _scaffoldKey,
              context: context,
              appTitle:'Marcações',
              funcData: (DateTime datetime) {
                marcacao.data = datetime;
              },
              listdecoration: listdecoration,
              controller: _controller,
              body: Center(
                  child: !connectionStatus.hasConnection ? const Text('Verifique sua Conexão com Internet') :
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
