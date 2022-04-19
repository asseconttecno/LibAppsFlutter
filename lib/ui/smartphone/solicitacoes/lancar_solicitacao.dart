import 'lancar_marcacao.dart';
import '../../../services/memorando/memorando_manager.dart';
import '../../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'lancar_justificativa.dart';


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

    return SingleChildScrollView(
      child: context.watch<MemorandosManager>().dropdownValue == "Atestado" ?
        LancarJustificativa() : LancarMarcacao(),
    );
  }
}
