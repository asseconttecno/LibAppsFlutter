import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:assecontservices/assecontservices.dart';

class DetalhesJustificativas extends StatelessWidget {
  Memorandos memorando;
  String get status {
    if(memorando.status == 1){
      return "Pendente";
    }else if(memorando.status == 2){
      return "Aprovado";
    }else if(memorando.status == 3){
      return "Reprovado";
    }else{
      return "";
    }
  }

  DetalhesJustificativas(this.memorando);

  Widget card(String menu, String valor){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(menu, style: TextStyle(fontSize: 14),),
          SizedBox(width: 5,),
          Text(valor, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        width: 500,
        height: 160,
        child: ListView(
            children: [
              card("Status:", status ),
              card("Solicitado em:", memorando.dataSolicitacao == null ? '' :
                "${DateFormat("dd/MM/yyyy").format(memorando.dataSolicitacao!)}" ),
              card("Data Solicitação:", memorando.data == null ? '' :
                  DateFormat("dd/MM/yyyy").format(memorando.data!) ),
              SizedBox(height: 15,),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Descrição:",),
                Text(memorando.descricao ?? '',)
              ],),

        ]),
    );
  }
}
