

import 'package:intl/intl.dart';

class Apontamento {
  DateTime datainicio = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime datatermino = DateTime(DateTime.now().year, DateTime.now().month+1, 1).subtract(Duration(days: 1));
  String? descricao;

  Apontamento.aponta({this.descricao, required this.datainicio, required this.datatermino});

  Apontamento.fromMap(Map? map) {
    if(map?.containsKey("DataInicial") ?? false){
      List _i = map!["DataInicial"].split("/");
      List _f = map["DataFinal"].split("/");
      this.datainicio  = DateTime(int.parse(_i[2]), int.parse(_i[1]), int.parse(_i[0]));
      this.datatermino  = DateTime(int.parse(_f[2]), int.parse(_f[1]), int.parse(_f[0]));
      this.descricao = map["Descricao"] ?? '';
    }else{
      this.datainicio  = DateTime(DateTime.now().year, DateTime.now().month, 1);
      this.datatermino  = DateTime(DateTime.now().year, DateTime.now().month+1, 1).subtract(Duration(days: 1));
      this.descricao = DateFormat('MMMM yyyy').format(DateTime.now());
    }
  }
}