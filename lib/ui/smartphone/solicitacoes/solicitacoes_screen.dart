import '../../../common/actions/actions.dart';
import '../../../model/memorando/memorando.dart';
import '../../../services/memorando/memorando_manager.dart';
import '../../../services/usuario/users_manager.dart';
import '../../../settintgs.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'lancar_solicitacao.dart';
import 'solicitacoes_detalhes.dart';


class Solicitacoes extends StatefulWidget {
  @override
  _SolicitacoesState createState() => _SolicitacoesState();
}

class _SolicitacoesState extends State<Solicitacoes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Memorandos> listamemorando = [];
  bool load = true;
  late DateTime inicio;
  late DateTime fim;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    inicio = context.read<UserManager>().usuario?.aponta?.datainicio ?? DateTime.now().subtract(Duration(days: 15));
    fim = context.read<UserManager>().usuario?.aponta?.datatermino ?? DateTime.now().add(Duration(days: 15));
    context.read<MemorandosManager>().getMemorandos(inicio, fim);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightfull = MediaQuery.of(context).size.height;
    double height = heightfull - AppBar().preferredSize.height - MediaQuery.of(context).padding.top ;

    return Consumer<MemorandosManager>(
          builder: (_,memorandos,__){
            listamemorando = memorandos.memorandos;

            return Scaffold(key: _scaffoldKey,
                  appBar: AppBar(
                    title: Text("Solicitações"),
                    centerTitle: true,
                    actions: [
                      actions(context)
                    ],
                  ),

                  body: Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 60, color: Theme.of(context).scaffoldBackgroundColor))
                    ),
                    //constraints: BoxConstraints.expand(),
                    child: Container(
                      child: Column(
                        //alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                                color: context.watch<Settings>().darkTemas ?
                                Theme.of(context).primaryColor :
                                Settings.corPribar,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(45),
                                  bottomLeft: Radius.circular(45),
                                )
                            ),
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () async {
                                  final DateTimeRange? picked = await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(DateTime.now().year + 1),
                                  );
                                  if (picked != null ) {
                                      memorandos.getMemorandos(picked.start, picked.end);
                                      setState(() {
                                        inicio = picked.start;
                                        fim = picked.end;
                                      });
                                  }
                                },
                                child: Text(
                                    DateFormat('dd/MM/yyyy').format(inicio) + " - " +
                                        DateFormat('dd/MM/yyyy').format(fim),
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                )
                            ),
                          ),
                          Container(
                            //height: ,
                            child: SingleChildScrollView(
                              child: Container(
                                height: height - 100 - 75,
                                padding: EdgeInsets.all(10),
                                child: LiveList(
                                  showItemInterval: Duration(milliseconds: 0),
                                  showItemDuration: Duration(milliseconds: 180),
                                  itemCount: listamemorando.length,
                                  itemBuilder: (BuildContext context, int indice, Animation<double> animation){
                                    String _diasolicitacao = '';
                                    String _horasolicitacao = '';
                                    String _data = '';
                                    String _descricao = '';
                                    int _status = 0;
                                    if(listamemorando.length > 0 && listamemorando[indice].data != null ){
                                      _diasolicitacao = DateFormat('dd/MM', 'pt_BR').
                                      format( listamemorando[indice].dataSolicitacao! ).toUpperCase();
                                      _data = DateFormat('dd/MM/yyyy').format( listamemorando[indice].data! );
                                      _horasolicitacao = listamemorando[indice].horaSolicitacao!;
                                      _descricao = listamemorando[indice].descricao!;
                                      _status = listamemorando[indice].status!;
                                    }

                                    return FadeTransition(
                                      opacity: Tween<double>(
                                        begin: 0, end: 1,
                                      ).animate(animation),
                                      child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: Offset(0, -0.1),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: GestureDetector(
                                              onTap: (){
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Center(child: Text('Detalhes Solicitado'.toUpperCase(),
                                                          textAlign: TextAlign.center,
                                                        )),
                                                        titlePadding: EdgeInsets.only(top: 30, left: 10, right: 10),
                                                        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                                                            color: context.watch<Settings>().darkTemas ?
                                                            Colors.white : Colors.black),
                                                        content: Container(
                                                          child: DetalhesJustificativas(listamemorando[indice]),
                                                        ),
                                                      );
                                                    }
                                                );
                                              },
                                              child: Card(
                                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  child: Padding( padding: const EdgeInsets.all(8.0),
                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Padding(padding: EdgeInsets.only(
                                                            left: 5, right: 5,bottom: 5, top: 5 ),
                                                          child: Text("${_horasolicitacao}\n${_diasolicitacao}",
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text( "Data: ${_data}\n${_descricao}" ,
                                                            overflow: TextOverflow.ellipsis,
                                                            softWrap: true,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          child: _status == 2 ?
                                                          Image.asset('assets/imagens/check.png') :
                                                          _status == 3 ?
                                                          Image.asset('assets/imagens/erro.png', color: Colors.red,) :
                                                          _status == 1 ?
                                                          Image.asset('assets/imagens/pending.png', color: Settings.corPri,)
                                                              : Container(),
                                                        )
                                                      ],),
                                                  )
                                              )
                                          )
                                      ),
                                    );
                                  },
                                ),
                              )

                              //ListSolicitacoes(listamemorando, height - 100 - 75),
                            ),
                          )
                      ],
                  ),
                    ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                  backgroundColor: Settings.corPri,
                  child: Center(
                      child: Icon(Icons.add, size: 30, color: Colors.white,)
                  ),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Column(mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(child: Text('LANÇAR SOLICITAÇÃO'),),
                                  DropdownButton<String>(
                                    value: context.watch<MemorandosManager>().dropdownValue,
                                    isExpanded: true,
                                    iconSize: 24,
                                    elevation: 16,
                                    icon: Icon(Icons.arrow_drop_down,),
                                    style: TextStyle(fontSize: 16,
                                        color: context.watch<Settings>().darkTemas ?
                                        Colors.white: Colors.black),
                                    underline: Container(height: 1, color: Colors.grey),
                                    onChanged: ( newValue) {
                                      context.read<MemorandosManager>().dropdownValue = newValue!;
                                    },
                                    items: <String>["Atestado", "Marcação", ]
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ]),
                            //titlePadding: EdgeInsets.only(top: 30, left: 10, right: 10),
                            titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                                color: context.watch<Settings>().darkTemas ?
                                Colors.white : Colors.black),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            content: Container(
                                child: LancarSolicitacao()
                            ),
                          );
                        }
                    );
                    memorandos.getMemorandos(inicio, fim);
                  }
              ),
            );
        }
    );
  }
}

ListSolicitacoes(List<Memorandos> listamemorando, double value, ScrollController controller){
  return SingleChildScrollView(
    child: Container(
        height: value,
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            controller: controller,
            //showItemInterval: Duration(milliseconds: 0),
            //showItemDuration: Duration(milliseconds: 180),
            itemCount: listamemorando.length ,
            itemBuilder: (BuildContext context, int indice, ){
              String _diasolicitacao = '';
              String _horasolicitacao = '';
              String _data = '';
              String _descricao = '';
              int _status = 0;
              if(listamemorando.length > 0 && listamemorando[indice].data != null){
                _diasolicitacao = DateFormat('dd/MM', 'pt_BR').
                format( listamemorando[indice].dataSolicitacao! ).toUpperCase();
                _data = DateFormat('dd/MM/yyyy').format( listamemorando[indice].data! );
                _horasolicitacao = listamemorando[indice].horaSolicitacao!;
                _descricao = listamemorando[indice].descricao!;
                _status = listamemorando[indice].status!;
              }

              return GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Center(child: Text('Detalhes Solicitado'.toUpperCase(),
                              textAlign: TextAlign.center,
                            )),
                            titlePadding: EdgeInsets.only(top: 30, left: 10, right: 10),
                            titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                                color: context.watch<Settings>().darkTemas ?
                                Colors.white : Colors.black),
                            content: Container(
                              child: DetalhesJustificativas(listamemorando[indice]),
                            ),
                          );
                        }
                    );
                  },
                  child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Padding( padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(
                                left: 5, right: 5,bottom: 5, top: 5 ),
                              child: Text("${_horasolicitacao}\n${_diasolicitacao}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text( "Data: ${_data}\n${_descricao}" ,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              width: 50,
                              child: _status == 2 ?
                              Image.asset('assets/imagens/check.png') :
                              _status == 3 ?
                              Image.asset('assets/imagens/erro.png', color: Colors.red,) :
                              _status == 1 ?
                              Image.asset('assets/imagens/pending.png', color: Settings.corPri,)
                                  : Container(),
                            )
                          ],),
                      )
                  )
              );
            },
          ),
    ),
  );
}