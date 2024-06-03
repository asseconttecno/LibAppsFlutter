
import 'package:assecontservices/assecontservices.dart';

import '../../../enums/holerite_tipo.dart';


class HoleriteModel {
  List<DatumHolerite>? data;
  MetaHolerite? meta;

  HoleriteModel({
    this.data,
    this.meta,
  });

  factory HoleriteModel.fromMap(Map<String, dynamic> json) => HoleriteModel(
    data: json["data"] == null ? [] : List<DatumHolerite>.from(json["data"]!.map((x) => DatumHolerite.fromMap(x))),
    meta: json["meta"] == null ? null : MetaHolerite.fromMap(json["meta"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "meta": meta?.toMap(),
  };
}

class DatumHolerite {
  int? id;
  DatumAttributesHolerite? attributes;

  DatumHolerite({
    this.id,
    this.attributes,
  });

  factory DatumHolerite.fromMap(Map<String, dynamic> json) => DatumHolerite(
    id: json["id"],
    attributes: json["attributes"] == null ? null : DatumAttributesHolerite.fromMap(json["attributes"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "attributes": attributes?.toMap(),
  };

  ChartColum chartColum(){
    return ChartColum(id ?? 0,
        '${attributes?.competence ?? ''}\n${attributes?.type.toName
            .replaceAll('Recibo de ', '').replaceAll('13º Salário', '13º')
            .replaceAll('Participação Remunerada nos Resultados', 'PLR') ?? ''}',
        attributes?.data?.funcionarioResumo?.liquido ?? 0
    );
  }
}

class DatumAttributesHolerite {
  String? cpf;
  String? name;
  String? office;
  AttributesDataHolerite? data;
  DateTime? createdAt;
  DateTime? updatedAt;
  HoleriteTipo type;
  String? month;
  String? year;
  DateTime? createDate;
  String? registration;
  String? competence;
  String? rg;
  String? phone;
  int? baseSalary;
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
  dynamic signedAt;
  EmployeeHolerite? employee;
  String? file;

  DatumAttributesHolerite({
    this.cpf,
    this.name,
    this.office,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.type = HoleriteTipo.Nenhum,
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
    this.employee,
    this.file,
  });

  factory DatumAttributesHolerite.fromMap(Map<String, dynamic> json) => DatumAttributesHolerite(
    cpf: json["cpf"],
    name: json["name"],
    office: json["office"],
    data: json["data"] == null ? null : AttributesDataHolerite.fromMap(json["data"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    type: HoleriteTipo.getEnum(int.tryParse(json["type"])),
    month: json["month"],
    year: json["year"],
    createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
    registration: json["registration"],
    competence: json["competence"],
    rg: json["rg"],
    phone: json["phone"],
    baseSalary: json["baseSalary"],
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
    signedAt: json["signedAt"],
    employee: json["employee"] == null ? null : EmployeeHolerite.fromMap(json["employee"]),
    file: json["file"] == null ? null : json["file"]['data'],
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
    "signedAt": signedAt,
    "employee": employee?.toMap(),
  };
}

class AttributesDataHolerite {
  int? cbo;
  String? cpf;
  String? reg;
  bool? erro;
  String? nome;
  dynamic chapa;
  String? cnpjcpf;
  DateTime? admissao;
  List<dynamic>? rawLines;
  int? setorLocal;
  List<dynamic>? errorFields;
  dynamic mensagemErro;
  FuncionarioResumo? funcionarioResumo;
  List<FuncionarioEvento>? funcionarioEventos;

  AttributesDataHolerite({
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

  factory AttributesDataHolerite.fromMap(Map<String, dynamic> json) => AttributesDataHolerite(
    cbo: json["cbo"],
    cpf: json["cpf"],
    reg: json["reg"],
    erro: json["erro"],
    nome: json["nome"],
    chapa: json["chapa"],
    cnpjcpf: json["cnpjcpf"],
    admissao: json["admissao"] == null ? null : DateTime.parse(json["admissao"]),
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

class EmployeeHolerite {
  EmployeeData? data;

  EmployeeHolerite({
    this.data,
  });

  factory EmployeeHolerite.fromMap(Map<String, dynamic> json) => EmployeeHolerite(
    data: json["data"] == null ? null : EmployeeData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data?.toMap(),
  };
}

class EmployeeData {
  int? id;
  DataAttributes? attributes;

  EmployeeData({
    this.id,
    this.attributes,
  });

  factory EmployeeData.fromMap(Map<String, dynamic> json) => EmployeeData(
    id: json["id"],
    attributes: json["attributes"] == null ? null : DataAttributes.fromMap(json["attributes"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "attributes": attributes?.toMap(),
  };
}

class DataAttributes {
  String? nome;
  String? cpf;
  String? phone;
  String? email;
  int? baseSalary;
  String? office;
  String? sector;
  String? ctps;
  String? syndicate;
  String? codeBank;
  String? accountBank;
  String? typeBank;
  String? pixKeyBank;
  String? agencyBank;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? reg;
  bool? isPreRegistered;

  DataAttributes({
    this.nome,
    this.cpf,
    this.phone,
    this.email,
    this.baseSalary,
    this.office,
    this.sector,
    this.ctps,
    this.syndicate,
    this.codeBank,
    this.accountBank,
    this.typeBank,
    this.pixKeyBank,
    this.agencyBank,
    this.createdAt,
    this.updatedAt,
    this.reg,
    this.isPreRegistered,
  });

  factory DataAttributes.fromMap(Map<String, dynamic> json) => DataAttributes(
    nome: json["nome"],
    cpf: json["cpf"],
    phone: json["phone"],
    email: json["email"],
    baseSalary: json["baseSalary"],
    office: json["office"],
    sector: json["sector"],
    ctps: json["ctps"],
    syndicate: json["syndicate"],
    codeBank: json["codeBank"],
    accountBank: json["accountBank"],
    typeBank: json["typeBank"],
    pixKeyBank: json["pixKeyBank"],
    agencyBank: json["agencyBank"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    reg: json["reg"],
    isPreRegistered: json["isPreRegistered"],
  );

  Map<String, dynamic> toMap() => {
    "nome": nome,
    "cpf": cpf,
    "phone": phone,
    "email": email,
    "baseSalary": baseSalary,
    "office": office,
    "sector": sector,
    "ctps": ctps,
    "syndicate": syndicate,
    "codeBank": codeBank,
    "accountBank": accountBank,
    "typeBank": typeBank,
    "pixKeyBank": pixKeyBank,
    "agencyBank": agencyBank,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "reg": reg,
    "isPreRegistered": isPreRegistered,
  };
}

class MetaHolerite {
  PaginationHolerite? pagination;

  MetaHolerite({
    this.pagination,
  });

  factory MetaHolerite.fromMap(Map<String, dynamic> json) => MetaHolerite(
    pagination: json["pagination"] == null ? null : PaginationHolerite.fromMap(json["pagination"]),
  );

  Map<String, dynamic> toMap() => {
    "pagination": pagination?.toMap(),
  };
}

class PaginationHolerite {
  int? page;
  int? pageSize;
  int? pageCount;
  int? total;

  PaginationHolerite({
    this.page,
    this.pageSize,
    this.pageCount,
    this.total,
  });

  factory PaginationHolerite.fromMap(Map<String, dynamic> json) => PaginationHolerite(
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