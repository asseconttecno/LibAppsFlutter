import 'dart:convert';

class HomePontoModel {
  String? totalFalta;
  String? totalBancoHoras;
  String? totalExtras;
  String? totalDescontos;
  List<ExpedienteList>? expedienteList;
  bool? marcacoesPendentes;

  HomePontoModel({
    this.totalFalta,
    this.totalBancoHoras,
    this.totalExtras,
    this.totalDescontos,
    this.expedienteList,
    this.marcacoesPendentes,
  });

  factory HomePontoModel.fromJson(String str) => HomePontoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomePontoModel.fromMap(Map<String, dynamic> json) => HomePontoModel(
    totalFalta: json["TotalFalta"],
    totalBancoHoras: json["TotalBancoHoras"],
    totalExtras: json["TotalExtras"],
    totalDescontos: json["TotalDescontos"],
    expedienteList: json["ExpedienteList"] == null ? [] : List<ExpedienteList>.from(json["ExpedienteList"]!.map((x) => ExpedienteList.fromMap(x))),
    marcacoesPendentes: json["MarcacoesPendentes"],
  );

  Map<String, dynamic> toMap() => {
    "TotalFalta": totalFalta,
    "TotalBancoHoras": totalBancoHoras,
    "TotalExtras": totalExtras,
    "TotalDescontos": totalDescontos,
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
