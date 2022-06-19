

import 'resultadoItem.dart';

class HomeModel{
  List<ResultadoItemList>? resultadoItemList;
  String? ultimoResgistro;
  HomeFuncionario? funcionario;

  HomeModel({this.resultadoItemList, this.ultimoResgistro,this.funcionario,});

  HomeModel.fromMap(Map map){
    this.funcionario = HomeFuncionario.fromMap(map['Funcionario']);
    this.resultadoItemList = map['ResultadoItemList'].map((e) => ResultadoItemList.fromMap(e)).toList();
    this.ultimoResgistro = map['UltimaMarcacao'];
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
    this.nome = map['Nome'];
    this.cargo = map['Cargo'];
    this.permitirMarcarPonto = map['PermitirMarcarPonto'].toString() == 'true';
    this.permitirMarcarPontoOffline = map['PermitirMarcarPontoOffline'].toString() == 'true';
    this.capturarGps = map['CapturarGps'].toString() == 'true';
  }

}