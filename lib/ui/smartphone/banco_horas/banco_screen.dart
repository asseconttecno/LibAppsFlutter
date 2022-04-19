import '../../../common/actions/actions.dart';
import '../../../helper/conn.dart';
import '../../../model/banco_horas/banco_horas.dart';
import '../../../services/usuario/users_manager.dart';
import '../../../ui/smartphone/banco_horas/detalhes_banco.dart';
import '../../../services/banco_horas/banco_manager.dart';
import '../../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:provider/provider.dart';

class BancoHorasScreen extends StatefulWidget {
  @override
  _BancoHorasScreenState createState() => _BancoHorasScreenState();
}

class _BancoHorasScreenState extends State<BancoHorasScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DecorationItem> listdecoration = [];
  final CalendarWeekController _controller = CalendarWeekController();
  BancoHoras? _bancoHoras;
  DateTime _data = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  late Future<BancoHoras?> myFuture;

  @override
  void initState() {
    context.read<BancoManager>().getFuncionarioHistorico();
    super.initState();
    myFuture = dadosdia();
  }


  Future<BancoHoras?> dadosdia() async {
    try{
      _bancoHoras = context.read<BancoManager>().listabanco.firstWhere((element) =>
      DateTime(element.data!.year, element.data!.month,
          element.data!.day) == _data);
    }catch (e){
      _bancoHoras = null;
    }
    return _bancoHoras;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<BancoManager>(
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
                      decoration: Icon(Icons.circle, color: Settings.corPri,),
                      date: element.data
                  )
              );
            }else if((element.debitomin ?? 0) > 0 ){
              listdecoration.add(
                  DecorationItem(
                      decoration: Icon(Icons.circle, color: Colors.red,),
                      date: element.data
                  )
              );

            }else if((element.creditomin ?? 0) > 0){
              listdecoration.add(
                  DecorationItem(
                      decoration: Icon(Icons.circle, color: Colors.green,),
                      date: element.data
                  )
              );
            }
          }).toList();

          return Scaffold(key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Banco de Horas'),
                centerTitle: true,
                actions: [
                  actions(context),
                ],
              ),
              body: Container(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(4),
                        height: 110,
                        decoration: BoxDecoration(
                            color: context.watch<Settings>().darkTemas ?
                            Theme.of(context).primaryColor : Settings.corPribar,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(45),
                              bottomLeft: Radius.circular(45),
                            )
                        ),
                        child: CalendarWeek(
                            controller: _controller,
                            height: 50,
                            showMonth: true,
                            backgroundColor: Colors.transparent,
                            minDate: context.watch<UserManager>().usuario?.aponta?.datainicio,
                            maxDate: context.watch<UserManager>().usuario?.aponta?.datatermino,
                            dateStyle: TextStyle(color: Colors.white,),
                            dayOfWeekStyle: TextStyle(color: Settings.corPri),
                            todayDateStyle: TextStyle(color: Colors.white,),
                            monthStyle: TextStyle(color: Colors.white),
                            pressedDateBackgroundColor: Colors.white30,
                            pressedDateStyle: TextStyle(color: Colors.white),
                            weekendsStyle: TextStyle(color: Settings.corPri),
                            onDatePressed: (DateTime datetime) {
                              setState(() {
                                _data = datetime;
                                myFuture = dadosdia();
                              });
                            },
                            dayOfWeek: [
                              "Seg",
                              "Tec",
                              "Qua",
                              "Qui",
                              "Sex",
                              "Sab",
                              "Dom"
                            ],
                            month: [
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
                        )
                    ),
                    Expanded(
                      child: Center(
                          child:  !connectionStatus.hasConnection ? Text('Verifique sua Conexão com Internet') :
                          FutureBuilder<BancoHoras?>(
                            future: myFuture,
                            builder: (context, snapshot){
                              Widget resultado;
                              String? _saldo = saldoAnteror();
                              switch( snapshot.connectionState ){
                                case ConnectionState.none :
                                case ConnectionState.waiting :
                                  resultado = CircularProgressIndicator();
                                  break;
                                case ConnectionState.active :
                                case ConnectionState.done :
                                  if( snapshot.hasError ){
                                    resultado = GestureDetector(
                                        child: Icon(Icons.autorenew_outlined,
                                          color: Settings.corPri, size: 70,),
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
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}