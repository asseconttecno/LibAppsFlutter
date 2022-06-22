// To parse this JSON data, do
//
//     final informeRendimentosModel = informeRendimentosModelFromMap(jsonString);

import 'dart:convert';

class InformeRendimentosModel {
  InformeRendimentosModel({
    this.id,
    this.ano,
    this.anoReferencia,
    this.naturezaRendimento,
    this.total,
    this.contribuicaoPrevidenciaria,
    this.contribuicaoPrevidenciariaPrivada,
    this.pensaoAlimenticia,
    this.impostoRendaRetido,
    this.parcialIsenta,
    this.ajudaDeCusto,
    this.pensao,
    this.lucro,
    this.pagosTitular,
    this.recisaoContratoTrabalho,
    this.isentosOutros,
    this.salario13,
    this.retidoSalario13,
    this.liquidoOutros,
    this.totalTributavel,
    this.exclusaoAcaoJudicial,
    this.deducaoPrevidenciaria,
    this.deducaoPensaoAlimenticia,
    this.impostoRetidoFonte,
    this.isentosPensao,
    this.informacoesComplemetares,
    this.responsavelNome,
    this.data,
    this.cnpj,
    this.razaoSocial,
    this.cpf,
    this.nome,
    this.disponiblizado,
    this.visualizado,
  });

  int? id;
  dynamic ano;
  String? anoReferencia;
  dynamic naturezaRendimento;
  int? total;
  int? contribuicaoPrevidenciaria;
  int? contribuicaoPrevidenciariaPrivada;
  int? pensaoAlimenticia;
  int? impostoRendaRetido;
  int? parcialIsenta;
  int? ajudaDeCusto;
  int? pensao;
  int? lucro;
  int? pagosTitular;
  int? recisaoContratoTrabalho;
  int? isentosOutros;
  int? salario13;
  int? retidoSalario13;
  int? liquidoOutros;
  int? totalTributavel;
  int? exclusaoAcaoJudicial;
  int? deducaoPrevidenciaria;
  int? deducaoPensaoAlimenticia;
  int? impostoRetidoFonte;
  int? isentosPensao;
  dynamic informacoesComplemetares;
  dynamic responsavelNome;
  dynamic data;
  dynamic cnpj;
  dynamic razaoSocial;
  dynamic cpf;
  dynamic nome;
  String? disponiblizado;
  String? visualizado;

  InformeRendimentosModel copyWith({
    int? id,
    dynamic ano,
    String? anoReferencia,
    dynamic naturezaRendimento,
    int? total,
    int? contribuicaoPrevidenciaria,
    int? contribuicaoPrevidenciariaPrivada,
    int? pensaoAlimenticia,
    int? impostoRendaRetido,
    int? parcialIsenta,
    int? ajudaDeCusto,
    int? pensao,
    int? lucro,
    int? pagosTitular,
    int? recisaoContratoTrabalho,
    int? isentosOutros,
    int? salario13,
    int? retidoSalario13,
    int? liquidoOutros,
    int? totalTributavel,
    int? exclusaoAcaoJudicial,
    int? deducaoPrevidenciaria,
    int? deducaoPensaoAlimenticia,
    int? impostoRetidoFonte,
    int? isentosPensao,
    dynamic informacoesComplemetares,
    dynamic responsavelNome,
    dynamic data,
    dynamic cnpj,
    dynamic razaoSocial,
    dynamic cpf,
    dynamic nome,
    String? disponiblizado,
    String? visualizado,
  }) =>
      InformeRendimentosModel(
        id: id ?? this.id,
        ano: ano ?? this.ano,
        anoReferencia: anoReferencia ?? this.anoReferencia,
        naturezaRendimento: naturezaRendimento ?? this.naturezaRendimento,
        total: total ?? this.total,
        contribuicaoPrevidenciaria: contribuicaoPrevidenciaria ?? this.contribuicaoPrevidenciaria,
        contribuicaoPrevidenciariaPrivada: contribuicaoPrevidenciariaPrivada ?? this.contribuicaoPrevidenciariaPrivada,
        pensaoAlimenticia: pensaoAlimenticia ?? this.pensaoAlimenticia,
        impostoRendaRetido: impostoRendaRetido ?? this.impostoRendaRetido,
        parcialIsenta: parcialIsenta ?? this.parcialIsenta,
        ajudaDeCusto: ajudaDeCusto ?? this.ajudaDeCusto,
        pensao: pensao ?? this.pensao,
        lucro: lucro ?? this.lucro,
        pagosTitular: pagosTitular ?? this.pagosTitular,
        recisaoContratoTrabalho: recisaoContratoTrabalho ?? this.recisaoContratoTrabalho,
        isentosOutros: isentosOutros ?? this.isentosOutros,
        salario13: salario13 ?? this.salario13,
        retidoSalario13: retidoSalario13 ?? this.retidoSalario13,
        liquidoOutros: liquidoOutros ?? this.liquidoOutros,
        totalTributavel: totalTributavel ?? this.totalTributavel,
        exclusaoAcaoJudicial: exclusaoAcaoJudicial ?? this.exclusaoAcaoJudicial,
        deducaoPrevidenciaria: deducaoPrevidenciaria ?? this.deducaoPrevidenciaria,
        deducaoPensaoAlimenticia: deducaoPensaoAlimenticia ?? this.deducaoPensaoAlimenticia,
        impostoRetidoFonte: impostoRetidoFonte ?? this.impostoRetidoFonte,
        isentosPensao: isentosPensao ?? this.isentosPensao,
        informacoesComplemetares: informacoesComplemetares ?? this.informacoesComplemetares,
        responsavelNome: responsavelNome ?? this.responsavelNome,
        data: data ?? this.data,
        cnpj: cnpj ?? this.cnpj,
        razaoSocial: razaoSocial ?? this.razaoSocial,
        cpf: cpf ?? this.cpf,
        nome: nome ?? this.nome,
        disponiblizado: disponiblizado ?? this.disponiblizado,
        visualizado: visualizado ?? this.visualizado,
      );

  factory InformeRendimentosModel.fromJson(String str) => InformeRendimentosModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InformeRendimentosModel.fromMap(Map<String, dynamic> json) => InformeRendimentosModel(
    id: json["id"] == null ? null : json["id"],
    ano: json["ano"],
    anoReferencia: json["anoReferencia"] == null ? null : json["anoReferencia"],
    naturezaRendimento: json["naturezaRendimento"],
    total: json["total"] == null ? null : json["total"],
    contribuicaoPrevidenciaria: json["contribuicaoPrevidenciaria"] == null ? null : json["contribuicaoPrevidenciaria"],
    contribuicaoPrevidenciariaPrivada: json["contribuicaoPrevidenciariaPrivada"] == null ? null : json["contribuicaoPrevidenciariaPrivada"],
    pensaoAlimenticia: json["pensaoAlimenticia"] == null ? null : json["pensaoAlimenticia"],
    impostoRendaRetido: json["impostoRendaRetido"] == null ? null : json["impostoRendaRetido"],
    parcialIsenta: json["parcialIsenta"] == null ? null : json["parcialIsenta"],
    ajudaDeCusto: json["ajudaDeCusto"] == null ? null : json["ajudaDeCusto"],
    pensao: json["pensao"] == null ? null : json["pensao"],
    lucro: json["lucro"] == null ? null : json["lucro"],
    pagosTitular: json["pagosTitular"] == null ? null : json["pagosTitular"],
    recisaoContratoTrabalho: json["recisaoContratoTrabalho"] == null ? null : json["recisaoContratoTrabalho"],
    isentosOutros: json["isentosOutros"] == null ? null : json["isentosOutros"],
    salario13: json["salario13"] == null ? null : json["salario13"],
    retidoSalario13: json["retidoSalario13"] == null ? null : json["retidoSalario13"],
    liquidoOutros: json["liquidoOutros"] == null ? null : json["liquidoOutros"],
    totalTributavel: json["totalTributavel"] == null ? null : json["totalTributavel"],
    exclusaoAcaoJudicial: json["exclusaoAcaoJudicial"] == null ? null : json["exclusaoAcaoJudicial"],
    deducaoPrevidenciaria: json["deducaoPrevidenciaria"] == null ? null : json["deducaoPrevidenciaria"],
    deducaoPensaoAlimenticia: json["deducaoPensaoAlimenticia"] == null ? null : json["deducaoPensaoAlimenticia"],
    impostoRetidoFonte: json["impostoRetidoFonte"] == null ? null : json["impostoRetidoFonte"],
    isentosPensao: json["isentosPensao"] == null ? null : json["isentosPensao"],
    informacoesComplemetares: json["informacoesComplemetares"],
    responsavelNome: json["responsavelNome"],
    data: json["data"],
    cnpj: json["cnpj"],
    razaoSocial: json["razaoSocial"],
    cpf: json["cpf"],
    nome: json["nome"],
    disponiblizado: json["disponiblizado"] == null ? null : json["disponiblizado"],
    visualizado: json["visualizado"] == null ? null : json["visualizado"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "ano": ano,
    "anoReferencia": anoReferencia == null ? null : anoReferencia,
    "naturezaRendimento": naturezaRendimento,
    "total": total == null ? null : total,
    "contribuicaoPrevidenciaria": contribuicaoPrevidenciaria == null ? null : contribuicaoPrevidenciaria,
    "contribuicaoPrevidenciariaPrivada": contribuicaoPrevidenciariaPrivada == null ? null : contribuicaoPrevidenciariaPrivada,
    "pensaoAlimenticia": pensaoAlimenticia == null ? null : pensaoAlimenticia,
    "impostoRendaRetido": impostoRendaRetido == null ? null : impostoRendaRetido,
    "parcialIsenta": parcialIsenta == null ? null : parcialIsenta,
    "ajudaDeCusto": ajudaDeCusto == null ? null : ajudaDeCusto,
    "pensao": pensao == null ? null : pensao,
    "lucro": lucro == null ? null : lucro,
    "pagosTitular": pagosTitular == null ? null : pagosTitular,
    "recisaoContratoTrabalho": recisaoContratoTrabalho == null ? null : recisaoContratoTrabalho,
    "isentosOutros": isentosOutros == null ? null : isentosOutros,
    "salario13": salario13 == null ? null : salario13,
    "retidoSalario13": retidoSalario13 == null ? null : retidoSalario13,
    "liquidoOutros": liquidoOutros == null ? null : liquidoOutros,
    "totalTributavel": totalTributavel == null ? null : totalTributavel,
    "exclusaoAcaoJudicial": exclusaoAcaoJudicial == null ? null : exclusaoAcaoJudicial,
    "deducaoPrevidenciaria": deducaoPrevidenciaria == null ? null : deducaoPrevidenciaria,
    "deducaoPensaoAlimenticia": deducaoPensaoAlimenticia == null ? null : deducaoPensaoAlimenticia,
    "impostoRetidoFonte": impostoRetidoFonte == null ? null : impostoRetidoFonte,
    "isentosPensao": isentosPensao == null ? null : isentosPensao,
    "informacoesComplemetares": informacoesComplemetares,
    "responsavelNome": responsavelNome,
    "data": data,
    "cnpj": cnpj,
    "razaoSocial": razaoSocial,
    "cpf": cpf,
    "nome": nome,
    "disponiblizado": disponiblizado == null ? null : disponiblizado,
    "visualizado": visualizado == null ? null : visualizado,
  };
}
