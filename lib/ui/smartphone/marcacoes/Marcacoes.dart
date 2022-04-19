import '../../../common/actions/actions.dart';
import '../../../helper/conn.dart';
import '../../../model/marcacao/marcacao.dart';
import '../../../services/usuario/users_manager.dart';
import '../../../ui/smartphone/marcacoes/detelhes_marcacao.dart';
import '../../../services/marcacao/marcacao_manager.dart';
import '../../../settintgs.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  Marcacao? _marcacao;
  DateTime _data = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late Future<Marcacao?> myFuture;

  Future<Marcacao?> getFuture() async {
      try{
        _marcacao = context.read<MarcacaoManager>().listamarcacao.firstWhere((element) =>
        DateTime(element.datahora!.year, element.datahora!.month,
            element.datahora!.day) == _data) ;
      }catch (e){
        _marcacao = null;
      }
      return _marcacao;

  }

  @override
  void initState() {
    context.read<MarcacaoManager>().getEspelho();
    super.initState();
    myFuture = getFuture();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MarcacaoManager>(
        builder: (_, marcacao, __){
          //if(!start){
            marcacao.listamarcacao.map((element) {
              if(((element.resultado?.atrasosmin ?? 0) > 0 || (element.resultado?.faltasDias ?? 0) > 0)
                  && (element.resultado?.extrasmin ?? 0)> 0){
                listdecoration.add(
                    DecorationItem(
                        decoration: Icon(Icons.circle, color: Settings.corPri,),
                        date: element.datahora
                    )
                );
              }else if((element.resultado?.atrasosmin ?? 0) > 0 || (element.resultado?.faltasDias ?? 0) > 0){
                  listdecoration.add(
                      DecorationItem(
                          decoration: Icon(Icons.circle, color: Colors.red,),
                          date: element.datahora
                      )
                  );

              }else if((element.resultado?.extrasmin ?? 0) > 0){
                  listdecoration.add(
                      DecorationItem(
                          decoration: Icon(Icons.circle, color: Colors.green,),
                          date: element.datahora
                      )
                  );
              }else if((element.resultado?.abonosmin ?? 0) > 0){
                listdecoration.add(
                    DecorationItem(
                        decoration: Icon(Icons.circle, color: Colors.white,),
                        date: element.datahora
                    )
                );
              }
            }).toList();
            //start = true;
          //}
          double width = MediaQuery.of(context).size.width;

          return Scaffold(key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Marcações'),
                centerTitle: true,
                actions: [
                  actions(context),
                ],
              ),
              body: Container(

                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        height: 110, width: width,
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
                                  myFuture = getFuture();
                                });
                              },
                              dayOfWeek: [
                                "Seg",
                                "Tec",
                                "Qua",
                                "Qui",
                                "Se",
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
                          child: !connectionStatus.hasConnection ? Text('Verifique sua Conexão com Internet') :
                          FutureBuilder<Marcacao?>(
                            future: myFuture,
                            builder: (context, snapshot){
                              Widget resultado;
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
                                            myFuture = getFuture();
                                          });
                                        }
                                    );
                                  }else {
                                    resultado = DetalhesMarcacao(snapshot.data, _data);
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
