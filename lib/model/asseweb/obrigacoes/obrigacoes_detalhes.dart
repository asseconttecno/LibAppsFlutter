import 'dart:convert';

import '../../../enums/enums.dart';
import '../../../utils/utils.dart';


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
    this.ativo,
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
  StatusTimeLine? statusTimeLine;
  bool? ativo;


  factory ObrigacoesDetalhesModel.fromJson(String str) => ObrigacoesDetalhesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ObrigacoesDetalhesModel.fromMap(Map<String, dynamic> json) => ObrigacoesDetalhesModel(
    obrigacaoDescricao: json["obrigacaoDescricao"],
    obrigacaoTipo: json["obrigacaoTipo"],
    responsavel: json["responsavel"],
    vencimento: json["vencimento"] == null ? null : Validacoes.stringToDataBr(json["vencimento"].toString()),
    competencia: json["competencia"],
    clienteId: json["clienteId"],
    obrigacaoArquivoId: json["obrigacaoArquivoId"],
    disponivelPor: json["disponivelPor"],
    disponivelEm: json["disponivelEm"] == null ? null : Validacoes.stringToDataBr(json["disponivelEm"].toString()),
    visualizadoPor: json["visualizadoPor"],
    visualizadoEm: json["visualizadoEm"] == null ? null : Validacoes.stringToDataBr(json["visualizadoEm"].toString()),
    emailEnviadoEm: json["emailEnviadoEm"] == null ? null : Validacoes.stringToDataBr(json["emailEnviadoEm"].toString()),
    smsEnviadoEm: json["smsEnviadoEm"] == null ? null : Validacoes.stringToDataBr(json["smsEnviadoEm"].toString()),
    ativo: json["ativo"],
  );

  Map<String, dynamic> toMap() => {
    "obrigacaoDescricao": obrigacaoDescricao,
    "obrigacaoTipo": obrigacaoTipo,
    "responsavel": responsavel,
    "vencimento": vencimento,
    "competencia": competencia,
    "clienteId": clienteId,
    "obrigacaoArquivoId": obrigacaoArquivoId,
    "disponivelPor": disponivelPor,
    "disponivelEm": disponivelEm,
    "visualizadoPor": visualizadoPor,
    "visualizadoEm": visualizadoEm,
    "emailEnviadoEm": emailEnviadoEm,
    "smsEnviadoEm": smsEnviadoEm,
    "ativo": ativo,
  };
}
