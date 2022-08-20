import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'lancar_marcacao.dart';
import 'lancar_justificativa.dart';
import 'package:assecontservices/assecontservices.dart';


class LancarSolicitacao extends StatefulWidget {
  DateTime? data;
  LancarSolicitacao({this.data});

  @override
  _LancarSolicitacaoState createState() => _LancarSolicitacaoState();
}

class _LancarSolicitacaoState extends State<LancarSolicitacao> {
  bool start = true;

  @override
  Widget build(BuildContext context) {
    if(start && widget.data != null){
      context.read<MemorandosManager>().controlerData.text =
          DateFormat("dd/MM/yyyy").format(widget.data!);
      start = false;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: DropdownButton<String>(
            value: context.watch<MemorandosManager>().dropdownValue,
            isExpanded: true,
            iconSize: 24,
            elevation: 16,
            icon: Icon(Icons.arrow_drop_down,),
            style: TextStyle(fontSize: 16,
                color: context.read<Config>().darkTemas ?
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
        ),
        SingleChildScrollView(
          child: context.watch<MemorandosManager>().dropdownValue == "Atestado" ?
            LancarJustificativa() : LancarMarcacao(),
        ),
      ],
    );
  }
}
