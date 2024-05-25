// To parse this JSON data, do
//
//     final holeriteModel = holeriteModelFromMap(jsonString);

import 'dart:convert';

import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';


class HoleriteModel {
  List<DatumHolerite>? data;
  Meta? meta;

  HoleriteModel({
    this.data,
    this.meta,
  });

  factory HoleriteModel.fromMap(Map<String, dynamic> json) => HoleriteModel(
    data: json["data"] == null ? [] : List<DatumHolerite>.from(json["data"]!.map((x) => DatumHolerite.fromMap(x))),
    meta: json["meta"] == null ? null : Meta.fromMap(json["meta"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "meta": meta?.toMap(),
  };
}

class DatumHolerite {
  int? id;
  Attributes? attributes;

  DatumHolerite({
    this.id,
    this.attributes,
  });

  factory DatumHolerite.fromMap(Map<String, dynamic> json) => DatumHolerite(
    id: json["id"],
    attributes: json["attributes"] == null ? null : Attributes.fromMap(json["attributes"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "attributes": attributes?.toMap(),
  };
}

class Attributes {
  String? cpf;
  String? name;
  String? office;
  Data? data;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  String? month;
  String? year;
  DateTime? createDate;
  String? registration;
  String? competence;
  String? rg;
  String? phone;
  double? baseSalary;
  String? agencyAccount;
  String? email;
  String? sindicate;
  String? depIr;
  String? depSf;
  String? ctps;
  String? uploadId;
  String? importingUser;
  String? sheetType;
  bool? isSigned;
  DateTime? signedAt;

  Attributes({
    this.cpf,
    this.name,
    this.office,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.month,
    this.year,
    this.createDate,
    this.registration,
    this.competence,
    this.rg,
    this.phone,
    this.baseSalary,
    this.agencyAccount,
    this.email,
    this.sindicate,
    this.depIr,
    this.depSf,
    this.ctps,
    this.uploadId,
    this.importingUser,
    this.sheetType,
    this.isSigned,
    this.signedAt,
  });

  factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
    cpf: json["cpf"],
    name: json["name"],
    office: json["office"],
    data: json["data"] == null ? null : Data.fromMap(json["data"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    type: json["type"],
    month: json["month"],
    year: json["year"],
    createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
    registration: json["registration"],
    competence: json["competence"],
    rg: json["rg"],
    phone: json["phone"],
    baseSalary: json["baseSalary"]?.toDouble(),
    agencyAccount: json["agencyAccount"],
    email: json["email"],
    sindicate: json["sindicate"],
    depIr: json["depIr"],
    depSf: json["depSf"],
    ctps: json["ctps"],
    uploadId: json["uploadId"],
    importingUser: json["importingUser"],
    sheetType: json["sheetType"],
    isSigned: json["isSigned"],
    signedAt: json["signedAt"] == null ? null : DateTime.parse(json["signedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "cpf": cpf,
    "name": name,
    "office": office,
    "data": data?.toMap(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "type": type,
    "month": month,
    "year": year,
    "create_date": createDate?.toIso8601String(),
    "registration": registration,
    "competence": competence,
    "rg": rg,
    "phone": phone,
    "baseSalary": baseSalary,
    "agencyAccount": agencyAccount,
    "email": email,
    "sindicate": sindicate,
    "depIr": depIr,
    "depSf": depSf,
    "ctps": ctps,
    "uploadId": uploadId,
    "importingUser": importingUser,
    "sheetType": sheetType,
    "isSigned": isSigned,
    "signedAt": signedAt?.toIso8601String(),
  };
}

class Data {
  int? cbo;
  String? cpf;
  String? reg;
  bool? erro;
  String? nome;
  dynamic chapa;
  String? cnpjcpf;
  dynamic admissao;
  List<dynamic>? rawLines;
  int? setorLocal;
  List<dynamic>? errorFields;
  dynamic mensagemErro;
  FuncionarioResumo? funcionarioResumo;
  List<FuncionarioEvento>? funcionarioEventos;

  Data({
    this.cbo,
    this.cpf,
    this.reg,
    this.erro,
    this.nome,
    this.chapa,
    this.cnpjcpf,
    this.admissao,
    this.rawLines,
    this.setorLocal,
    this.errorFields,
    this.mensagemErro,
    this.funcionarioResumo,
    this.funcionarioEventos,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    cbo: json["cbo"],
    cpf: json["cpf"],
    reg: json["reg"],
    erro: json["erro"],
    nome: json["nome"],
    chapa: json["chapa"],
    cnpjcpf: json["cnpjcpf"],
    admissao: json["admissao"],
    rawLines: json["rawLines"] == null ? [] : List<dynamic>.from(json["rawLines"]!.map((x) => x)),
    setorLocal: json["setorLocal"],
    errorFields: json["errorFields"] == null ? [] : List<dynamic>.from(json["errorFields"]!.map((x) => x)),
    mensagemErro: json["mensagemErro"],
    funcionarioResumo: json["funcionarioResumo"] == null ? null : FuncionarioResumo.fromMap(json["funcionarioResumo"]),
    funcionarioEventos: json["funcionarioEventos"] == null ? [] : List<FuncionarioEvento>.from(json["funcionarioEventos"]!.map((x) => FuncionarioEvento.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "cbo": cbo,
    "cpf": cpf,
    "reg": reg,
    "erro": erro,
    "nome": nome,
    "chapa": chapa,
    "cnpjcpf": cnpjcpf,
    "admissao": admissao,
    "rawLines": rawLines == null ? [] : List<dynamic>.from(rawLines!.map((x) => x)),
    "setorLocal": setorLocal,
    "errorFields": errorFields == null ? [] : List<dynamic>.from(errorFields!.map((x) => x)),
    "mensagemErro": mensagemErro,
    "funcionarioResumo": funcionarioResumo?.toMap(),
    "funcionarioEventos": funcionarioEventos == null ? [] : List<dynamic>.from(funcionarioEventos!.map((x) => x.toMap())),
  };
}

class FuncionarioEvento {
  String? codigo;
  String? desconto;
  String? descricao;
  String? referencia;
  String? vencimento;

  FuncionarioEvento({
    this.codigo,
    this.desconto,
    this.descricao,
    this.referencia,
    this.vencimento,
  });

  factory FuncionarioEvento.fromMap(Map<String, dynamic> json) => FuncionarioEvento(
    codigo: json["codigo"],
    desconto: json["desconto"],
    descricao: json["descricao"],
    referencia: json["referencia"],
    vencimento: json["vencimento"],
  );

  Map<String, dynamic> toMap() => {
    "codigo": codigo,
    "desconto": desconto,
    "descricao": descricao,
    "referencia": referencia,
    "vencimento": vencimento,
  };
}

class FuncionarioResumo {
  String? banco;
  String? conta;
  String? frase;
  double? baseIr;
  String? funcao;
  String? credito;
  String? divisao;
  double? liquido;
  String? mesFgts;
  double? baseFgts;
  String? competencia;
  double? salarioBase;
  double? totalDescontos;
  double? salContribuicao;
  double? totalVencimentos;

  FuncionarioResumo({
    this.banco,
    this.conta,
    this.frase,
    this.baseIr,
    this.funcao,
    this.credito,
    this.divisao,
    this.liquido,
    this.mesFgts,
    this.baseFgts,
    this.competencia,
    this.salarioBase,
    this.totalDescontos,
    this.salContribuicao,
    this.totalVencimentos,
  });

  factory FuncionarioResumo.fromMap(Map<String, dynamic> json) => FuncionarioResumo(
    banco: json["banco"],
    conta: json["conta"],
    frase: json["frase"],
    baseIr: json["baseIR"] == null ? 0 : json["baseIR"].toString().toDouble(),
    funcao: json["funcao"],
    credito: json["credito"],
    divisao: json["divisao"],
    liquido: json["liquido"] == null ? 0 : json["liquido"].toString().toDouble(),
    mesFgts: json["mesFGTS"],
    baseFgts: json["baseFGTS"] == null ? 0 : json["baseFGTS"].toString().toDouble(),
    competencia: json["competencia"],
    salarioBase: json["salarioBase"] == null ? 0 : json["salarioBase"].toString().toDouble(),
    totalDescontos: json["totalDescontos"] == null ? 0 : json["totalDescontos"].toString().toDouble(),
    salContribuicao: json["salContribuicao"] == null ? 0 : json["salContribuicao"].toString().toDouble(),
    totalVencimentos: json["totalVencimentos"] == null ? 0 : json["totalVencimentos"].toString().toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "banco": banco,
    "conta": conta,
    "frase": frase,
    "baseIR": baseIr,
    "funcao": funcao,
    "credito": credito,
    "divisao": divisao,
    "liquido": liquido,
    "mesFGTS": mesFgts,
    "baseFGTS": baseFgts,
    "competencia": competencia,
    "salarioBase": salarioBase,
    "totalDescontos": totalDescontos,
    "salContribuicao": salContribuicao,
    "totalVencimentos": totalVencimentos,
  };
}

class Meta {
  Pagination? pagination;

  Meta({
    this.pagination,
  });

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
    pagination: json["pagination"] == null ? null : Pagination.fromMap(json["pagination"]),
  );

  Map<String, dynamic> toMap() => {
    "pagination": pagination?.toMap(),
  };
}

class Pagination {
  int? page;
  int? pageSize;
  int? pageCount;
  int? total;

  Pagination({
    this.page,
    this.pageSize,
    this.pageCount,
    this.total,
  });

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    pageSize: json["pageSize"],
    pageCount: json["pageCount"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "page": page,
    "pageSize": pageSize,
    "pageCount": pageCount,
    "total": total,
  };
}

class ChartPizza {
  final String desc;
  final double valor;

  ChartPizza(this.desc, this.valor);
}

class ChartColum {
  final int ind;
  final String data;
  final double valor;
  ChartColum(this.ind, this.data, this.valor);
}