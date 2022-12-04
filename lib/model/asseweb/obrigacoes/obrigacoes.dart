import 'dart:convert';

class Obrigacoes {
  Obrigacoes({
    this.obrigacao,
    this.obrigacaoClientePeriodo,
  });

  Obrigacao? obrigacao;
  ObrigacaoClientePeriodo? obrigacaoClientePeriodo;

  factory Obrigacoes.fromJson(String str) => Obrigacoes.fromMap(json.decode(str));


  factory Obrigacoes.fromMap(Map<String, dynamic> json) => Obrigacoes(
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
    id: json["id"] == null ? null : json["id"],
    description: json["description"] == null ? null : json["description"],
    sector: json["sector"] == null ? null : json["sector"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "description": description == null ? null : description,
    "sector": sector == null ? null : sector,
  };
}

class ObrigacaoClientePeriodo {
  ObrigacaoClientePeriodo({
    this.id,
    this.deadLine,
    this.finishedIn,
    this.completedBy,
  });

  int? id;
  String? deadLine;
  DateTime? finishedIn;
  int? completedBy;

  factory ObrigacaoClientePeriodo.fromJson(String str) => ObrigacaoClientePeriodo.fromMap(json.decode(str));

  factory ObrigacaoClientePeriodo.fromMap(Map<String, dynamic> json) => ObrigacaoClientePeriodo(
    id: json["id"] == null ? null : json["id"],
    deadLine: json["deadLine"] == null ? null : json["deadLine"],
    finishedIn: json["finishedIn"] == null ? null : DateTime.parse(json["finishedIn"]),
    completedBy: json["completedBy"] == null ? null : json["completedBy"],
  );

}
