
// To parse this JSON data, do
//
//     final marcacoesComprovanteModel = marcacoesComprovanteModelFromMap(jsonString);

import 'dart:convert';

class MarcacoesComprovanteModel {
  int? marcacaoId;
  DateTime? dataHora;

  MarcacoesComprovanteModel({
    this.marcacaoId,
    this.dataHora,
  });

  factory MarcacoesComprovanteModel.fromJson(String str) => MarcacoesComprovanteModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MarcacoesComprovanteModel.fromMap(Map<String, dynamic> json) => MarcacoesComprovanteModel(
    marcacaoId: json["MarcacaoId"],
    dataHora: json["DataHora"] == null ? null : DateTime.parse(json["DataHora"]),
  );

  Map<String, dynamic> toMap() => {
    "MarcacaoId": marcacaoId,
    "DataHora": dataHora?.toIso8601String(),
  };
}
