import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import '../solicitacoes/lancar_solicitacao.dart';
import '../solicitacoes/solicitacoes_screen.dart';

class DetalhesBanco extends StatefulWidget {
  BancoDiasList? bancoHoras;
  DateTime? dia;
  String? saldo;
  DetalhesBanco(this.bancoHoras, this.dia, this.saldo);

  @override
  _DetalhesMarcacaoState createState() => _DetalhesMarcacaoState();
}

class _DetalhesMarcacaoState extends State<DetalhesBanco> {
  final ScrollController scrollController = ScrollController();
  bool diaMaiorHoje = false;

  @override
  void initState() {
    if(widget.dia != null) {
      diaMaiorHoje = widget.dia!.compareTo(DateTime.now()) > 0;
    }
    super.initState();
  }

  Widget card(String menu, String valor){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText.text(menu,style: const TextStyle(fontSize: 20),),
          CustomText.text(valor.trim(),style: const TextStyle(fontSize: 20),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Memorandos> list = context.watch<MemorandosManager>().memorandoDia(widget.dia);



    return Scaffold(
          body: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 80,
                        color: Theme.of(context).scaffoldBackgroundColor))
            ),
            //height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15,),
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: CustomText.text('Resumo'),
                    ),
                    const SizedBox(height: 5,),
                    card("Creditos:", widget.bancoHoras?.credito == null || widget.bancoHoras?.credito == '' || diaMaiorHoje
                        ? "0:00" : widget.bancoHoras!.credito! ),
                    if(!diaMaiorHoje && widget.bancoHoras?.descricaoCredito != null && widget.bancoHoras?.descricaoCredito != '')
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: CustomText.text(widget.bancoHoras?.descricaoCredito ?? "",
                          style: const TextStyle(fontSize: 14),)
                    ),
                    const SizedBox(height: 10,),
                    card("Debitos:", widget.bancoHoras?.debito == null || widget.bancoHoras?.debito == '' || diaMaiorHoje
                        ? "0:00" : widget.bancoHoras!.debito! ),
                    if(!diaMaiorHoje && widget.bancoHoras?.descricaoDebito != null && widget.bancoHoras?.descricaoDebito != '')
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: CustomText.text(widget.bancoHoras?.descricaoDebito ?? "",
                            style: const TextStyle(fontSize: 14),)
                      ),

                    if(!diaMaiorHoje)
                    const SizedBox(height: 10,),
                    if(!diaMaiorHoje)
                    card("Saldo do dia:", widget.bancoHoras?.saldodia == null
                        ? "0:00" : widget.bancoHoras!.saldodia ),

                    if(widget.bancoHoras?.lancamentos != null && widget.bancoHoras?.lancamentos != '')
                      const SizedBox(height: 10,),
                    if(widget.bancoHoras?.lancamentos != null && widget.bancoHoras?.lancamentos != '')
                      card("Lançamentos Manual:", widget.bancoHoras!.lancamentos! ),
                    if(widget.bancoHoras?.descricaoLancamentos != null && widget.bancoHoras?.descricaoLancamentos != '')
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: CustomText.text(widget.bancoHoras?.descricaoLancamentos ?? "",
                            style: const TextStyle(fontSize: 14),)
                      ),


                    if(!diaMaiorHoje)
                    const SizedBox(height: 15,),
                    if(!diaMaiorHoje)
                    card("Saldo:", widget.bancoHoras?.saldo == null ? widget.saldo == null
                        ? "0:00" : widget.saldo! : widget.bancoHoras!.saldo!),

                    const SizedBox(height: 20,),
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: CustomText.text('Obs: Esses dados podem ser alterados ate o fechamento!'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: Divider(height: 2,),
                    ),

                    ListSolicitacoes( list, 90.0 * list.length, scrollController)
                  ]),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Config.corPri,
              onPressed: () async {
                CustomAlert.custom(
                  context: context,
                  titulo: 'LANÇAR SOLICITAÇÃO',
                  corpo: LancarSolicitacao(
                      data: widget.dia
                  ),
                );
              },
              label: CustomText.text('Solicitação'.toUpperCase(), style: const TextStyle(fontSize: 20, color: Colors.white),)
          ),
    );
  }
}
