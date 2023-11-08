import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'
;
import 'lancar_solicitacao.dart';
import 'solicitacoes_detalhes.dart';
import 'package:assecontservices/assecontservices.dart';


class Solicitacoes extends StatefulWidget {
  @override
  _SolicitacoesState createState() => _SolicitacoesState();
}

class _SolicitacoesState extends State<Solicitacoes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    inicio = context.read<UserPontoManager>().usuario?.periodo?.dataInicial ?? DateTime.now().subtract(const Duration(days: 15));
    fim = context.read<UserPontoManager>().usuario?.periodo?.dataFinal ?? DateTime.now().add(const Duration(days: 15));
    context.read<MemorandosManager>().getMemorandos(context.read<UserPontoManager>().usuario!, inicio, fim);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightfull = MediaQuery.of(context).size.height;
    double height = heightfull - AppBar().preferredSize.height - MediaQuery.of(context).padding.top ;

    return Consumer<MemorandosManager>(
          builder: (_,memorandos,__){
            listamemorando = memorandos.memorandos;

            return CustomScaffold.custom(
                  context: context,
                  key: _scaffoldKey,
                  appTitle:  "Solicitações",
                  height: 70,
                  appbar:  Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone
                          ? context.watch<Config>().darkTemas ? Colors.black : Colors.white : null,
                      border: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone
                          ? Border(top: BorderSide(color: Config.corPribar)) : null
                    ),
                    child: TextButton(
                        onPressed: () async {
                          final DateTimeRange? picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(DateTime.now().year + 1),
                          );
                          if (picked != null ) {
                            memorandos.getMemorandos(context.read<UserPontoManager>().usuario! ,picked.start, picked.end);
                            setState(() {
                              inicio = picked.start;
                              fim = picked.end;
                            });
                          }
                        },
                        child: CustomText.text(
                          DateFormat('dd/MM/yyyy').format(inicio) + " - " +
                              DateFormat('dd/MM/yyyy').format(fim),
                          style: TextStyle(color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                              && !ResponsiveBreakpoints.of(context).isPhone ?
                          context.watch<Config>().darkTemas ? Config.corPri : Config.corPribar : Colors.white, fontSize: 20),
                        )
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                            width: 60, color: Theme.of(context).scaffoldBackgroundColor))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: LiveList(
                        showItemInterval: const Duration(milliseconds: 0),
                        showItemDuration: const Duration(milliseconds: 180),
                        itemCount: listamemorando.length,
                        itemBuilder: (BuildContext context, int indice, Animation<double> animation){
                          String _diasolicitacao = '';
                          String _horasolicitacao = '';
                          String _data = '';
                          String _descricao = '';
                          int _status = 0;
                          if(listamemorando.isNotEmpty && listamemorando[indice].data != null ){
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
                                  begin: const Offset(0, -0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: GestureDetector(
                                    onTap: (){
                                      CustomAlert.custom(
                                          context: context,
                                          titulo: 'Detalhes Solicitado'.toUpperCase(),
                                          corpo: Container(
                                            child: DetalhesJustificativas(listamemorando[indice]),
                                          ),
                                      );
                                    },
                                    child: Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Padding( padding: const EdgeInsets.all(8.0),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(padding: const EdgeInsets.only(
                                                  left: 5, right: 5,bottom: 5, top: 5 ),
                                                child: CustomText.text("${_horasolicitacao}\n${_diasolicitacao}",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomText.text( "Data: ${_data}\n${_descricao}" ,
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
                                                Image.asset('assets/imagens/pending.png', color: Config.corPri,)
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
                    ),
              ),
              buttom: FloatingActionButton(
                  backgroundColor: Config.corPri,
                  child: const Center(
                      child: Icon(Icons.add, size: 30, color: Colors.white,)
                  ),
                  onPressed: () async {
                    await CustomAlert.custom(
                      context: context,
                      titulo: 'LANÇAR SOLICITAÇÃO',
                      corpo: Container(
                          child: LancarSolicitacao()
                      ),
                    );
                    memorandos.getMemorandos(context.read<UserPontoManager>().usuario! , inicio, fim);
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
        padding: const EdgeInsets.all(10),
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
              if(listamemorando.isNotEmpty && listamemorando[indice].data != null){
                _diasolicitacao = DateFormat('dd/MM', 'pt_BR').
                format( listamemorando[indice].dataSolicitacao! ).toUpperCase();
                _data = DateFormat('dd/MM/yyyy').format( listamemorando[indice].data! );
                _horasolicitacao = listamemorando[indice].horaSolicitacao!;
                _descricao = listamemorando[indice].descricao!;
                _status = listamemorando[indice].status!;
              }

              return GestureDetector(
                  onTap: (){
                    CustomAlert.custom(
                      context: context,
                      titulo: 'Detalhes Solicitado'.toUpperCase(),
                      corpo: Container(
                        child: DetalhesJustificativas(listamemorando[indice]),
                      ),
                    );
                  },
                  child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Padding( padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.only(
                                left: 5, right: 5,bottom: 5, top: 5 ),
                              child: CustomText.text("${_horasolicitacao}\n${_diasolicitacao}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: CustomText.text( "Data: ${_data}\n${_descricao}" ,
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
                              Image.asset('assets/imagens/pending.png', color: Config.corPri,)
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