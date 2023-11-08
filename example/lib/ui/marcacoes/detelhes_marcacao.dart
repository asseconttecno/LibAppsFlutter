import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import '../solicitacoes/lancar_solicitacao.dart';
import '../solicitacoes/solicitacoes_screen.dart';


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
          CustomText.text(menu, style: const TextStyle(fontSize: 20),),
          CustomText.text(valor, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Memorandos> list = context.watch<MemorandosManager>().memorandoDia(widget.dia);

    return Scaffold(
          body: Container(
            decoration: (UserPontoManager().usuario?.app ?? false) ?
              BoxDecoration(
                  border: Border(bottom: BorderSide(width: 80,
                      color: Theme.of(context).scaffoldBackgroundColor))
              ) : null,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15,),
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: CustomText.text('Marcações'),
                    ),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: CustomText.text(widget.listaMarcacao?.marcacao.toString().
                          replaceAll("[", "").replaceAll("]", "").replaceAll(",", " -") ?? "",
                          maxLines: 2, style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Divider(height: 2,),
                    ),
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: CustomText.text('Resumo'),
                    ),
                    const SizedBox(height: 5,),
                    card("Horas Extras:", widget.listaMarcacao?.resultado?.extras ?? "0:00"),
                    const SizedBox(height: 10,),
                    card("Noturno:", widget.listaMarcacao?.resultado?.noturno ?? "0:00"),
                    const SizedBox(height: 10,),
                    card("Abonos:", widget.listaMarcacao?.resultado?.abono ?? "0:00"),
                    const SizedBox(height: 10,),
                    card("Descontos", widget.listaMarcacao?.resultado?.descontos ?? "0:00"),
                    const SizedBox(height: 10,),
                    card("Falta:", widget.listaMarcacao?.resultado?.faltasDias.toString() ?? "0"),
                    const SizedBox(height: 10,),
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: CustomText.text('Obs: Esses dados podem ser alterados ate o fechamento!'),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: Divider(height: 2,),
                    ),
                    //Expanded(child: null)
                    ListSolicitacoes( list, 90.0 * list.length, scrollController)
                  ]),
            ),
          ),
          floatingActionButtonLocation: (UserPontoManager().usuario?.app ?? false) ?
            FloatingActionButtonLocation.centerFloat : null,
          floatingActionButton: (UserPontoManager().usuario?.app ?? false) ?
            FloatingActionButton.extended(
              backgroundColor: Config.corPri,
              onPressed: () async {
                CustomAlert.custom(
                  context: context,
                  titulo: 'LANÇAR SOLICITAÇÃO',
                  corpo: Container(
                      child: LancarSolicitacao(
                          data: widget.dia
                      )
                  ),
                );
              },
              label: CustomText.text('Solicitação'.toUpperCase(), style: const TextStyle(fontSize: 20, color: Colors.white),)
          ) : null,
    );
  }
}
