

import 'package:intl/intl.dart';

class Apontamento {
  DateTime datainicio = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime datatermino = DateTime(DateTime.now().year, DateTime.now().month+1, 1).subtract(Duration(days: 1));
  String? descricao;

  Apontamento.padrao(){
    this.datainicio  = DateTime(DateTime.now().year, DateTime.now().month, 1);
    this.datatermino  = DateTime(DateTime.now().year, DateTime.now().month+1, 1).subtract(Duration(days: 1));
    this.descricao = DateFormat('MMMM yyyy').format(DateTime.now());
  }

  Apontamento.aponta({this.descricao, required this.datainicio, required this.datatermino});

  Apontamento.fromMap(Map? map) {
    if(map != null && map.containsKey("DataInicial")){
      this.datainicio  = DateTime.tryParse(map["DataInicial"].toString()) ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
      this.datatermino  = DateTime.tryParse(map["DataFinal"].toString()) ?? DateTime(DateTime.now().year, DateTime.now().month+1, 1).subtract(Duration(days: 1));
      this.descricao = map["Descricao"] ?? '';
    }else{
      this.datainicio  = DateTime(DateTime.now().year, DateTime.now().month, 1);
      this.datatermino  = DateTime(DateTime.now().year, DateTime.now().month+1, 1).subtract(Duration(days: 1));
      this.descricao = DateFormat('MMMM yyyy').format(DateTime.now());
    }
  }
}