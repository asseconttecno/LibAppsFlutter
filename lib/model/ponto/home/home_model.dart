

import 'resultadoItem.dart';

class HomePontoModel{
  List<ResultadoItemList>? resultadoItemList;
  String? ultimoResgistro;
  HomeFuncionario? funcionario;

  HomePontoModel({this.resultadoItemList, this.ultimoResgistro,this.funcionario,});

  HomePontoModel.fromMap(Map map){
    funcionario = HomeFuncionario.fromMap(map['Funcionario']);
    List items = map['ResultadoItemList'];
    resultadoItemList = items.map((e) => ResultadoItemList.fromMap(e)).toList();
    ultimoResgistro = map['UltimaMarcacao'];
  }
}

class HomeFuncionario {
  String? nome;
  String? cargo;
  bool? permitirMarcarPonto;
  bool? permitirMarcarPontoOffline;
  bool? capturarGps;

  HomeFuncionario({this.nome, this.cargo, this.permitirMarcarPonto,
    this.permitirMarcarPontoOffline, this.capturarGps});

  HomeFuncionario.fromMap(Map map){
    nome = map['Nome'];
    cargo = map['Cargo'];
    permitirMarcarPonto = map['PermitirMarcarPonto'].toString() == 'true';
    permitirMarcarPontoOffline = map['PermitirMarcarPontoOffline'].toString() == 'true';
    capturarGps = map['CapturarGps'].toString() == 'true';
  }

}