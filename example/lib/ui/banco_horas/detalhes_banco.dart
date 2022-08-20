import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import '../solicitacoes/lancar_solicitacao.dart';
import '../solicitacoes/solicitacoes_screen.dart';

class DetalhesBanco extends StatefulWidget {
  BancoHoras? bancoHoras;
  DateTime? dia;
  String? saldo;
  DetalhesBanco(this.bancoHoras, this.dia, this.saldo);

  @override
  _DetalhesMarcacaoState createState() => _DetalhesMarcacaoState();
}

class _DetalhesMarcacaoState extends State<DetalhesBanco> {
  final ScrollController scrollController = ScrollController();

  Widget card(String menu, String valor){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(menu,style: const TextStyle(fontSize: 20),),
          Text(valor,style: const TextStyle(fontSize: 20),),
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
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 80, color: Theme.of(context).scaffoldBackgroundColor))
            ),
            //height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Resumo'),
                    ),
                    const SizedBox(height: 5,),
                    card("Creditos:", widget.bancoHoras?.credito == null
                        ? "0:00" : widget.bancoHoras!.credito! ),
                    const SizedBox(height: 10,),
                    card("Debitos:", widget.bancoHoras?.debito == null
                        ? "0:00" : widget.bancoHoras!.debito! ),
                    const SizedBox(height: 10,),
                    card("Saldo do dia:", widget.bancoHoras?.saldodia == null
                        ? "0:00" : widget.bancoHoras!.saldodia! ),
                    const SizedBox(height: 10,),
                    card("Saldo:", widget.bancoHoras?.saldo == null ? widget.saldo == null
                        ? "0:00" : widget.saldo! : widget.bancoHoras!.saldo!),
                    const SizedBox(height: 10,),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: const Text("Descrição:", style: TextStyle(fontSize: 20),)
                    ),
                    const SizedBox(height: 5,),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Text(widget.bancoHoras?.descricao ?? "",
                          style: const TextStyle(fontSize: 18),)
                    ),

                    const SizedBox(height: 20,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Obs: Esses dados podem ser alterados ate o fechamento!'),
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
              label: Text('Solicitação'.toUpperCase(), style: const TextStyle(fontSize: 20, color: Colors.white),)
          ),
    );
  }
}
