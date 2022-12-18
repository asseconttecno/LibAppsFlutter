import 'dart:convert';

import 'package:assecontservices/assecontservices.dart';

class ObrigacoesDetalhesModel {
  ObrigacoesDetalhesModel({
    this.obrigacaoDescricao,
    this.obrigacaoTipo,
    this.responsavel,
    this.vencimento,
    this.competencia,
    this.clienteId,
    this.obrigacaoArquivoId,
    this.disponivelPor,
    this.disponivelEm,
    this.visualizadoPor,
    this.visualizadoEm,
    this.emailEnviadoEm,
    this.smsEnviadoEm,
  });

  String? obrigacaoDescricao;
  String? obrigacaoTipo;
  String? responsavel;
  DateTime? vencimento;
  String? competencia;
  int? clienteId;
  int? obrigacaoArquivoId;
  String? disponivelPor;
  DateTime? disponivelEm;
  String? visualizadoPor;
  DateTime? visualizadoEm;
  DateTime? emailEnviadoEm;
  DateTime? smsEnviadoEm;

  factory ObrigacoesDetalhesModel.fromJson(String str) => ObrigacoesDetalhesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ObrigacoesDetalhesModel.fromMap(Map<String, dynamic> json) => ObrigacoesDetalhesModel(
    obrigacaoDescricao: json["obrigacaoDescricao"] == null ? null : json["obrigacaoDescricao"],
    obrigacaoTipo: json["obrigacaoTipo"] == null ? null : json["obrigacaoTipo"],
    responsavel: json["responsavel"] == null ? null : json["responsavel"],
    vencimento: json["vencimento"] == null ? null : Validacoes.stringToDataBr(json["vencimento"]),
    competencia: json["competencia"] == null ? null : json["competencia"],
    clienteId: json["clienteId"] == null ? null : json["clienteId"],
    obrigacaoArquivoId: json["obrigacaoArquivoId"] == null ? null : json["obrigacaoArquivoId"],
    disponivelPor: json["disponivelPor"] == null ? null : json["disponivelPor"],
    disponivelEm: json["disponivelEm"] == null ? null : Validacoes.stringToDataBr(json["disponivelEm"]),
    visualizadoPor: json["visualizadoPor"] == null ? null : json["visualizadoPor"],
    visualizadoEm: json["visualizadoEm"] == null ? null : Validacoes.stringToDataBr(json["visualizadoEm"]),
    emailEnviadoEm: json["emailEnviadoEm"] == null ? null : Validacoes.stringToDataBr(json["emailEnviadoEm"]),
    smsEnviadoEm: json["smsEnviadoEm"] == null ? null : Validacoes.stringToDataBr(json["smsEnviadoEm"]),
  );

  Map<String, dynamic> toMap() => {
    "obrigacaoDescricao": obrigacaoDescricao == null ? null : obrigacaoDescricao,
    "obrigacaoTipo": obrigacaoTipo == null ? null : obrigacaoTipo,
    "responsavel": responsavel == null ? null : responsavel,
    "vencimento": vencimento == null ? null : vencimento,
    "competencia": competencia == null ? null : competencia,
    "clienteId": clienteId == null ? null : clienteId,
    "obrigacaoArquivoId": obrigacaoArquivoId == null ? null : obrigacaoArquivoId,
    "disponivelPor": disponivelPor == null ? null : disponivelPor,
    "disponivelEm": disponivelEm == null ? null : disponivelEm,
    "visualizadoPor": visualizadoPor == null ? null : visualizadoPor,
    "visualizadoEm": visualizadoEm == null ? null : visualizadoEm,
    "emailEnviadoEm": emailEnviadoEm == null ? null : emailEnviadoEm,
    "smsEnviadoEm": smsEnviadoEm == null ? null : smsEnviadoEm,
  };
}
