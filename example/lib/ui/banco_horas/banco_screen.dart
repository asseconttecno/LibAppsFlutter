import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import 'detalhes_banco.dart';

class BancoHorasScreen extends StatefulWidget {
  @override
  _BancoHorasScreenState createState() => _BancoHorasScreenState();
}

class _BancoHorasScreenState extends State<BancoHorasScreen> {
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CalendarWeekController _controller = CalendarWeekController();

  @override
  void initState() {
    context.read<BancoHorasManager>().getFuncionarioHistorico();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Consumer<BancoHorasManager>(
        builder: (_, banco, __){


          String? saldoAnteror() {
            String? _saldo;
              try{
                if(banco.listabanco.any((element) =>
                  element.data != null ? banco.data.compareTo(
                    DateTime(element.data!.year, element.data!.month, element.data!.day)) > 0 : false
                )) {
                  _saldo = banco.listabanco.lastWhere((element) =>
                  element.data != null ? banco.data.compareTo(
                      DateTime(element.data!.year, element.data!.month,
                          element.data!.day)) > 0 : false
                  ).saldo;
                }
              }catch (e){
                _saldo = null;
              }

            return _saldo;
          }

          return CustomScaffold.calendario(
            key: _scaffoldKey,
            context: context,
            appTitle:'Banco de Horas',
            funcData: (DateTime datetime) {
              banco.data = datetime;
            },
            listdecoration: banco.listdecoration,
            controller: _controller,
            dataInit: banco.data,
            dataMin: context.read<UserPontoManager>().usuario?.periodo?.dataInicial,
            dataMax: context.read<UserPontoManager>().usuario?.periodo?.dataFinal,
            body: Center(
                child:  !connectionStatus.hasConnection ?   CustomText.text('Verifique sua Conexão com Internet') :
                FutureBuilder<BancoDiasList?>(
                  future: banco.getBancodia(),
                  builder: (context, snapshot){
                    Widget resultado = Container();
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
                                setState(() {});
                              }
                          );
                        }else {
                          resultado = DetalhesBanco(snapshot.data, banco.data, _saldo);
                        }
                        break;
                    }
                    return resultado;
                  },
                )
            ),
          );
        }
    );
  }
}