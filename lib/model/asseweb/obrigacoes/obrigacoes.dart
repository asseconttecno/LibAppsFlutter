

import 'dart:convert';

import '../../../enums/enums.dart';
import '../../../utils/utils.dart';

class ObrigacaoModel {
  ObrigacaoModel({
    this.obrigacaoId,
    this.obrcliperId,
    this.grupo,
    this.descricao,
    this.responsavel,
    this.cliente,
    this.status,
    this.vencimento,
    this.prazo,
    this.concluidoEm,
    this.prazoOuVencimento,
    this.statusDescricao,
    this.competencia,
    this.tipoeDescricao,
    this.temMemo,
    this.darfVencido,
    this.darfDataArrecadacao,
    this.notaServico,
    this.prestadorNome,
    this.notaFiscal,
    this.solicitacaoAdmissao,
    this.solicitacaoFerias,
    this.solicitacaoRecisao,
    this.solicitacaoNome,
    this.concluidoPor,
    this.obrigacaoArquivoId,
    this.ultimaBaixa,
    this.numeroArquivos,
    this.abonadoPor,
    this.abonadoEm,
    this.numeroNotasUnificadas,
    this.diasMes,
    this.homeOffice,
    this.nomeSupervisor,
  });

  int? obrigacaoId;
  int? obrcliperId;
  String? grupo;
  String? descricao;
  String? responsavel;
  int? cliente;
  int? status;
  DateTime? vencimento;
  DateTime? prazo;
  DateTime? concluidoEm;
  DateTime? prazoOuVencimento;
  String? statusDescricao;
  String? competencia;
  ObrigacaoTipo? tipoeDescricao;
  bool? temMemo;
  bool? darfVencido;
  DateTime? darfDataArrecadacao;
  String? notaServico;
  String? prestadorNome;
  String? notaFiscal;
  String? solicitacaoAdmissao;
  String? solicitacaoFerias;
  String? solicitacaoRecisao;
  String? solicitacaoNome;
  String? concluidoPor;
  int? obrigacaoArquivoId;
  String? ultimaBaixa;
  int? numeroArquivos;
  String? abonadoPor;
  DateTime? abonadoEm;
  int? numeroNotasUnificadas;
  String? diasMes;
  bool? homeOffice;
  String? nomeSupervisor;

  factory ObrigacaoModel.fromJson(String str) => ObrigacaoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ObrigacaoModel.fromMap(Map<String, dynamic> json) => ObrigacaoModel(
    obrigacaoId: json["obrigacaoId"],
    obrcliperId: json["obrcliperId"],
    grupo: json["grupo"],
    descricao: json["descricao"],
    responsavel: json["responsavel"],
    cliente: json["cliente"],
    status: json["status"],
    vencimento: Validacoes.stringToDataBr(json["vencimento"].toString()),
    prazo: Validacoes.stringToDataBr(json["prazo"].toString()),
    concluidoEm: Validacoes.stringToDataBr(json["concluidoEm"].toString()),
    prazoOuVencimento: Validacoes.stringToDataBr(json["prazoOuVencimento"].toString()),
    statusDescricao: json["statusDescricao"],
    competencia: json["competencia"],
    tipoeDescricao: ObrigacaoTipo.getEnum(json["tipoeDescricao"].toString()),
    temMemo: json["temMemo"],
    darfVencido: json["darfVencido"],
    darfDataArrecadacao: Validacoes.stringToDataBr(json["darfDataArrecadacao"].toString()),
    notaServico: json["notaServico"],
    prestadorNome: json["prestadorNome"],
    notaFiscal: json["notaFiscal"],
    solicitacaoAdmissao: json["solicitacaoAdmissao"],
    solicitacaoFerias: json["solicitacaoFerias"],
    solicitacaoRecisao: json["solicitacaoRecisao"],
    solicitacaoNome: json["solicitacaoNome"],
    concluidoPor: json["concluidoPor"],
    obrigacaoArquivoId: json["obrigacaoArquivoId"],
    ultimaBaixa: json["ultimaBaixa"],
    numeroArquivos: json["numeroArquivos"],
    abonadoPor: json["abonadoPor"],
    abonadoEm: Validacoes.stringToDataBr(json["abonadoEm"].toString()),
    numeroNotasUnificadas: json["numeroNotasUnificadas"],
    diasMes: json["diasMes"].toString(),
    homeOffice: json["homeOffice"],
    nomeSupervisor: json["nomeSupervisor"],
  );

  Map<String, dynamic> toMap() => {
    "obrigacaoId": obrigacaoId,
    "obrcliperId": obrcliperId,
    "grupo": grupo,
    "descricao": descricao,
    "responsavel": responsavel,
    "cliente": cliente,
    "status": status,
    "vencimento": vencimento,
    "prazo": prazo,
    "concluidoEm": concluidoEm,
    "prazoOuVencimento": prazoOuVencimento,
    "statusDescricao": statusDescricao,
    "competencia": competencia,
    "tipoeDescricao": tipoeDescricao,
    "temMemo": temMemo,
    "darfVencido": darfVencido,
    "darfDataArrecadacao": darfDataArrecadacao,
    "notaServico": notaServico,
    "prestadorNome": prestadorNome,
    "notaFiscal": notaFiscal,
    "solicitacaoAdmissao": solicitacaoAdmissao,
    "solicitacaoFerias": solicitacaoFerias,
    "solicitacaoRecisao": solicitacaoRecisao,
    "solicitacaoNome": solicitacaoNome,
    "concluidoPor": concluidoPor,
    "obrigacaoArquivoId": obrigacaoArquivoId,
    "ultimaBaixa": ultimaBaixa,
    "numeroArquivos": numeroArquivos,
    "abonadoPor": abonadoPor,
    "abonadoEm": abonadoEm,
    "numeroNotasUnificadas": numeroNotasUnificadas,
    "diasMes": diasMes,
    "homeOffice": homeOffice,
    "nomeSupervisor": nomeSupervisor,
  };
}
