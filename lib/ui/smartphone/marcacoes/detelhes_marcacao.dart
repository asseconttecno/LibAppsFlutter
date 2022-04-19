import '../../../model/marcacao/marcacao.dart';
import '../../../model/memorando/memorando.dart';
import '../../../services/memorando/memorando_manager.dart';
import '../../../services/usuario/users_manager.dart';
import '../../../settintgs.dart';
import '../../../ui/smartphone/solicitacoes/lancar_solicitacao.dart';
import '../../../ui/smartphone/solicitacoes/solicitacoes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class DetalhesMarcacao extends StatefulWidget {
  Marcacao? listaMarcacao;
  DateTime? dia;
  DetalhesMarcacao(this.listaMarcacao, this.dia);

  @override
  _DetalhesMarcacaoState createState() => _DetalhesMarcacaoState();
}

class _DetalhesMarcacaoState extends State<DetalhesMarcacao> {
  final ScrollController scrollController = ScrollController();
  Widget card(String menu, String valor){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(menu, style: TextStyle(fontSize: 20),),
          Text(valor, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Memorandos> list = context.watch<MemorandosManager>().memorandos.where(
    (e) => e.data == widget.dia).toList();
    return Scaffold(
          body: Container(
            decoration: (UserManager().usuario?.master ?? false) ? BoxDecoration(
                border: Border(bottom: BorderSide(width: 80, color: Theme.of(context).scaffoldBackgroundColor))
            ) : null,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Marcações'),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Text(widget.listaMarcacao?.marcacao.toString().
                          replaceAll("[", "").replaceAll("]", "").replaceAll(",", " -") ?? "",
                          maxLines: 2, style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Divider(height: 2,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Resumo'),
                    ),
                    SizedBox(height: 5,),
                    card("Horas Extras:", widget.listaMarcacao?.resultado?.extras ?? "0:00"),
                    SizedBox(height: 10,),
                    card("Noturno:", widget.listaMarcacao?.resultado?.noturno ?? "0:00"),
                    SizedBox(height: 10,),
                    card("Abonos:", widget.listaMarcacao?.resultado?.abono ?? "0:00"),
                    SizedBox(height: 10,),
                    card("Descontos", widget.listaMarcacao?.resultado?.descontos ?? "0:00"),
                    SizedBox(height: 10,),
                    card("Falta:", widget.listaMarcacao?.resultado?.faltasDias.toString() ?? "0"),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Obs: Esses dados podem ser alterados ate o fechamento!'),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: Divider(height: 2,),
                    ),
                    //Expanded(child: null)
                    ListSolicitacoes( list, 90.0 * list.length, scrollController)
                  ]),
            ),
          ),
          floatingActionButtonLocation: (UserManager().usuario?.master ?? false) ?
            FloatingActionButtonLocation.centerFloat : null,
          floatingActionButton: (UserManager().usuario?.master ?? false) ?
            FloatingActionButton.extended(
              backgroundColor: Settings.corPri,
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
                        //titlePadding: EdgeInsets.symmetric(vertical: 30),
                        titleTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
                            color: context.watch<Settings>().darkTemas ?
                            Colors.white : Colors.black),

                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        content: Container(
                            child: LancarSolicitacao(
                                data: widget.dia
                            )
                        ),
                      );
                    }
                );
              },
              label: Text('Solicitação'.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.white),)
          ) : null,
    );
  }
}
