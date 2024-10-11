import 'dart:convert';


import '../../../enums/obrigacao_status.dart';
import '../../../utils/validacoes.dart';

class ObrigacoesHomeModel {
  ObrigacoesHomeModel({
    this.obrigacao,
    this.obrigacaoClientePeriodo,
  });

  Obrigacao? obrigacao;
  ObrigacaoClientePeriodo? obrigacaoClientePeriodo;

  factory ObrigacoesHomeModel.fromJson(String str) => ObrigacoesHomeModel.fromMap(json.decode(str));


  factory ObrigacoesHomeModel.fromMap(Map<String, dynamic> json) => ObrigacoesHomeModel(
    obrigacao: json["obrigacao"] == null ? null : Obrigacao.fromMap(json["obrigacao"]),
    obrigacaoClientePeriodo: json["obrigacaoClientePeriodo"] == null ? null : ObrigacaoClientePeriodo.fromMap(json["obrigacaoClientePeriodo"]),
  );

}

class Obrigacao {
  Obrigacao({
    this.id,
    this.description,
    this.sector,
  });

  int? id;
  String? description;
  int? sector;

  factory Obrigacao.fromJson(String str) => Obrigacao.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Obrigacao.fromMap(Map<String, dynamic> json) => Obrigacao(
    id: json["id"],
    description: json["description"],
    sector: json["sector"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "description": description,
    "sector": sector,
  };
}

class ObrigacaoClientePeriodo {
  ObrigacaoClientePeriodo({
    this.id,
    this.deadLine,
    this.finishedIn,
    this.completedBy,
    this.status = ObrigacaoStatus.Nenhum,
  });

  int? id;
  DateTime? deadLine;
  DateTime? finishedIn;
  int? completedBy;
  ObrigacaoStatus status;

  factory ObrigacaoClientePeriodo.fromJson(String str) => ObrigacaoClientePeriodo.fromMap(json.decode(str));

  factory ObrigacaoClientePeriodo.fromMap(Map<String, dynamic> json) => ObrigacaoClientePeriodo(
    id: json["id"],
    deadLine: json["deadLine"] == null ? null : Validacoes.stringToDataBr( json["deadLine"].toString() ),
    finishedIn: json["finishedIn"] == null ? null : DateTime.parse(json["finishedIn"]),
    completedBy: json["completedBy"],
    status: ObrigacaoStatus.fromInt( int.tryParse(json["completedBy"].toString()) ?? -1 ),
  );

}