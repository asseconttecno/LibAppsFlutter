import 'dart:convert';

class HomePontoModel {
  List<ResultadosList>? resultadosList;
  List<ExpedienteList>? expedienteList;
  bool? marcacoesPendentes;

  HomePontoModel({
    this.resultadosList,
    this.expedienteList,
    this.marcacoesPendentes,
  });

  factory HomePontoModel.fromJson(String str) => HomePontoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomePontoModel.fromMap(Map<String, dynamic> json) => HomePontoModel(
    resultadosList: json["ResultadosList"] == null ? [] : List<ResultadosList>.from(json["ResultadosList"]!.map((x) => ResultadosList.fromMap(x))),
    expedienteList: json["ExpedienteList"] == null ? [] : List<ExpedienteList>.from(json["ExpedienteList"]!.map((x) => ExpedienteList.fromMap(x))),
    marcacoesPendentes: json["MarcacoesPendentes"],
  );

  Map<String, dynamic> toMap() => {
    "ResultadosList": resultadosList == null ? [] : List<dynamic>.from(resultadosList!.map((x) => x.toMap())),
    "ExpedienteList": expedienteList == null ? [] : List<dynamic>.from(expedienteList!.map((x) => x.toMap())),
    "MarcacoesPendentes": marcacoesPendentes,
  };
}

class ExpedienteList {
  DateTime? data;
  String? horario;

  ExpedienteList({
    this.data,
    this.horario,
  });

  factory ExpedienteList.fromJson(String str) => ExpedienteList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExpedienteList.fromMap(Map<String, dynamic> json) => ExpedienteList(
    data: json["Data"] == null ? null : DateTime.parse(json["Data"]),
    horario: json["Horario"],
  );

  Map<String, dynamic> toMap() => {
    "Data": data?.toIso8601String(),
    "Horario": horario,
  };
}

class ResultadosList {
  int? id;
  String? titulo;
  String? valor;

  ResultadosList({
    this.id,
    this.titulo,
    this.valor,
  });

  factory ResultadosList.fromJson(String str) => ResultadosList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultadosList.fromMap(Map<String, dynamic> json) => ResultadosList(
    id: json["Id"],
    titulo: json["Titulo"],
    valor: json["Valor"],
  );

  Map<String, dynamic> toMap() => {
    "Titulo": titulo,
    "Valor": valor,
  };
}