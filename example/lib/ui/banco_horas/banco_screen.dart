import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import 'detalhes_banco.dart';

class BancoHorasScreen extends StatefulWidget {
  @override
  _BancoHorasScreenState createState() => _BancoHorasScreenState();
}

class _BancoHorasScreenState extends State<BancoHorasScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DecorationItem> listdecoration = [];

  BancoHoras? _bancoHoras;
  DateTime _data = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  late Future<BancoHoras?> myFuture;

  @override
  void initState() {
    context.read<BancoHorasManager>().getFuncionarioHistorico(context.read<UserPontoManager>().usuario);
    super.initState();
    myFuture = dadosdia();
  }


  Future<BancoHoras?> dadosdia() async {
    try{
      _bancoHoras = context.read<BancoHorasManager>().listabanco.firstWhere((element) =>
      DateTime(element.data!.year, element.data!.month,
          element.data!.day) == _data);
    }catch (e){
      _bancoHoras = null;
    }
    return _bancoHoras;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<BancoHorasManager>(
        builder: (_, banco, __){


          String? saldoAnteror() {
            String? _saldo;
            try{
              _saldo = banco.listabanco.lastWhere((element) =>
                element.data != null ? _data.compareTo(
                    DateTime(element.data!.year, element.data!.month,
                        element.data!.day)) > 0 : false
              ).saldo;
            }catch (e){
              _saldo = null;
            }
            return _saldo;
          }

          banco.listabanco.map((element) {
            if((element.debitomin ?? 0) > 0 && (element.creditomin ?? 0) > 0){
              listdecoration.add(
                  DecorationItem(
                      decoration: Icon(Icons.circle, color: Config.corPri,),
                      date: element.data
                  )
              );
            }else if((element.debitomin ?? 0) > 0 ){
              listdecoration.add(
                  DecorationItem(
                      decoration: const Icon(Icons.circle, color: Colors.red,),
                      date: element.data
                  )
              );

            }else if((element.creditomin ?? 0) > 0){
              listdecoration.add(
                  DecorationItem(
                      decoration: const Icon(Icons.circle, color: Colors.green,),
                      date: element.data
                  )
              );
            }
          }).toList();

          return CustomScaffold.calendario(
              key: _scaffoldKey,
              context: context,
              appTitle:'Banco de Horas',
              funcData: (DateTime datetime) {
                setState(() {
                  _data = datetime;
                  myFuture = dadosdia();
                });
              },
              listdecoration: listdecoration,
              body: Expanded(
                child: Center(
                    child:  !connectionStatus.hasConnection ? const Text('Verifique sua Conexão com Internet') :
                    FutureBuilder<BancoHoras?>(
                      future: myFuture,
                      builder: (context, snapshot){
                        Widget resultado;
                        String? _saldo = saldoAnteror();
                        switch( snapshot.connectionState ){
                          case ConnectionState.none :
                          case ConnectionState.waiting :
                            resultado = const Center(child: CircularProgressIndicator());
                            break;
                          case ConnectionState.active :
                          case ConnectionState.done :
                            if( snapshot.hasError ){
                              resultado = GestureDetector(
                                  child: Icon(Icons.autorenew_outlined,
                                    color: Config.corPri, size: 70,),
                                  onTap: (){
                                    setState(() {
                                      myFuture = dadosdia();
                                    });
                                  }
                              );
                            }else {
                              resultado = DetalhesBanco(snapshot.data, _data, _saldo);
                            }
                            break;
                        }
                        return resultado;
                      },
                    )
                ),
              ), 
          );
        }
    );
  }
}