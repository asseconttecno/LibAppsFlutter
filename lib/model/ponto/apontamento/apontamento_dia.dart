
// To parse this JSON data, do
//
//     final apontamentoDiaModel = apontamentoDiaModelFromMap(jsonString);

import 'dart:convert';

ApontamentoDiaModel apontamentoDiaModelFromMap(String str) => ApontamentoDiaModel.fromMap(json.decode(str));

String apontamentoDiaModelToMap(ApontamentoDiaModel data) => json.encode(data.toMap());

class ApontamentoDiaModel {
  final List<MarcacoeDia>? marcacoes;
  final List<MarcacoeDia>? marcacoesInvalidas;
  final String? expediente;
  final String? trabalhar;
  final String? extras;
  final String? extrasFolga;
  final String? desconto;
  final String? adcNot;
  final String? abono;
  final String? falta;

  const ApontamentoDiaModel({
    this.marcacoes,
    this.marcacoesInvalidas,
    this.expediente,
    this.trabalhar,
    this.extras,
    this.extrasFolga,
    this.desconto,
    this.adcNot,
    this.abono,
    this.falta,
  });

  factory ApontamentoDiaModel.fromMap(Map<String, dynamic> json) => ApontamentoDiaModel(
    marcacoes: json["Marcacoes"] == null ? [] : List<MarcacoeDia>.from(json["Marcacoes"]!.map((x) => MarcacoeDia.fromMap(x))),
    marcacoesInvalidas: json["MarcacoesInvalidas"] == null ? [] : List<MarcacoeDia>.from(json["MarcacoesInvalidas"]!.map((x) => MarcacoeDia.fromMap(x))),
    expediente: json["Expediente"],
    trabalhar: json["Trabalhar"],
    extras: json["Extras"],
    extrasFolga: json["ExtrasFolga"],
    desconto: json["Desconto"],
    adcNot: json["AdcNot"],
    abono: json["Abono"],
    falta: json["Falta"],
  );

  Map<String, dynamic> toMap() => {
    "Marcacoes": marcacoes == null ? [] : List<dynamic>.from(marcacoes!.map((x) => x.toMap())),
    "MarcacoesInvalidas": marcacoesInvalidas == null ? [] : List<dynamic>.from(marcacoesInvalidas!.map((x) => x.toMap())),
    "Expediente": expediente,
    "Trabalhar": trabalhar,
    "Extras": extras,
    "ExtrasFolga": extrasFolga,
    "Desconto": desconto,
    "AdcNot": adcNot,
    "Falta": falta,
    "Abono": abono,
  };
}

class MarcacoeDia {
  final String? horario;
  final MarcacaoStatus status;

  const MarcacoeDia({
    this.horario,
    this.status = MarcacaoStatus.none,
  });

  factory MarcacoeDia.fromMap(Map<String, dynamic> json) => MarcacoeDia(
    horario: json["Horario"],
    status: MarcacaoStatus.fromInt(int.tryParse(json["Status"].toString()) ?? 0) ,
  );

  Map<String, dynamic> toMap() => {
    "Horario": horario,
    "Status": status.value,
  };
}


enum MarcacaoStatus {
  none(0, ""),
  entradaOk(1, "Entrada"),
  saidaOk(2, "Saída"),
  foraFaixa(3, "Fora do Intervalo Permitido"),
  crachaInvalido(4, "Crachá Inválido"),
  desconsiderado(5, "Desconsiderada"),
  preAssinalado(6, "Pré-Assinalada no Intervalo"),
  jaImportada(7, "Já Importada"),
  pisInvalido(8, "Pis Inválido"),
  inclusaoFolga(9, "Incluída em Folga"),
  foraPerimetroOnline(10, "Fora do Perímetro Online"),
  foraPerimetroOffline(11, "Fora do Perímetro Offline"),
  cpfInvalido(12, "CPF Inválido"),
  erro(20, "Erro");

  final int value;
  final String description;

  const MarcacaoStatus(this.value, this.description);

  static MarcacaoStatus fromInt(int value) {
    return MarcacaoStatus.values.firstWhere(
          (e) => e.value == value,
      orElse: () => MarcacaoStatus.none,
    );
  }
}
