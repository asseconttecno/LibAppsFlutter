
import 'package:assecontservices/assecontservices.dart';

import '../../../enums/holerite_tipo.dart';


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


class HoleriteModel {
  final List<DatumHolerite>? data;
  final MetaHolerite? meta;

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
  final int? id;
  final DatumAttributes? attributes;

  DatumHolerite({
    this.id,
    this.attributes,
  });

  factory DatumHolerite.fromMap(Map<String, dynamic> json) => DatumHolerite(
    id: json["id"],
    attributes: json["attributes"] == null ? null : DatumAttributes.fromMap(json["attributes"]),
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

class DatumAttributes {
  final String? cpf;
  final String? name;
  final String? office;
  final AttributesData? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final HoleriteTipo type;
  final String? month;
  final String? year;
  final DateTime? createDate;
  final String? registration;
  final String? competence;
  final dynamic rg;
  final dynamic phone;
  final dynamic baseSalary;
  final dynamic agencyAccount;
  final dynamic email;
  final dynamic sindicate;
  final dynamic depIr;
  final dynamic depSf;
  final dynamic ctps;
  final String? uploadId;
  final String? importingUser;
  final String? sheetType;
  final bool? isSigned;
  final DateTime? signedAt;
  final FileClass? file;

  DatumAttributes({
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
    this.file,
  });

  factory DatumAttributes.fromMap(Map<String, dynamic> json) => DatumAttributes(
    cpf: json["cpf"],
    name: json["name"],
    office: json["office"],
    data: json["data"] == null ? null : AttributesData.fromMap(json["data"]),
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
    signedAt: json["signedAt"] == null ? null : DateTime.parse(json["signedAt"]),
    file: json["file"] == null ? null : FileClass.fromMap(json["file"]),
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
    "file": file?.toMap(),
  };
}

class AttributesData {
  final int? cbo;
  final String? cpf;
  final String? reg;
  final bool? erro;
  final String? nome;
  final dynamic chapa;
  final String? cnpjcpf;
  final String? admissao;
  final List<dynamic>? rawLines;
  final int? setorLocal;
  final List<dynamic>? errorFields;
  final dynamic mensagemErro;
  final FuncionarioResumo? funcionarioResumo;
  final List<FuncionarioEvento>? funcionarioEventos;

  AttributesData({
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

  factory AttributesData.fromMap(Map<String, dynamic> json) => AttributesData(
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
  final String? codigo;
  final String? desconto;
  final String? descricao;
  final String? referencia;
  final String? vencimento;

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
  final String? banco;
  final String? conta;
  final String? frase;
  final String? baseIr;
  final String? funcao;
  final String? credito;
  final String? divisao;
  final double? liquido;
  final String? mesFgts;
  final String? baseFgts;
  final String? competencia;
  final double? salarioBase;
  final double? totalDescontos;
  final double? salContribuicao;
  final double? totalVencimentos;

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
    baseIr: json["baseIR"],
    funcao: json["funcao"],
    credito: json["credito"],
    divisao: json["divisao"],
    liquido: double.parse(json["liquido"]?.replaceAll('.', '').replaceAll(',', '.') ?? '0'),
    mesFgts: json["mesFGTS"],
    baseFgts: json["baseFGTS"],
    competencia: json["competencia"],
    salarioBase: double.parse(json["salarioBase"]?.replaceAll('.', '').replaceAll(',', '.') ?? '0'),
    totalDescontos: double.parse(json["totalDescontos"]?.replaceAll('.', '').replaceAll(',', '.') ?? '0'),
    salContribuicao: double.parse(json["salContribuicao"]?.replaceAll('.', '').replaceAll(',', '.') ?? '0'),
    totalVencimentos: double.parse(json["totalVencimentos"]?.replaceAll('.', '').replaceAll(',', '.') ?? '0'),
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

class FileClass {
  final FileData? data;

  FileClass({
    this.data,
  });

  factory FileClass.fromMap(Map<String, dynamic> json) => FileClass(
    data: json["data"] == null ? null : FileData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data?.toMap(),
  };
}

class FileData {
  final int? id;
  final DataAttributes? attributes;

  FileData({
    this.id,
    this.attributes,
  });

  factory FileData.fromMap(Map<String, dynamic> json) => FileData(
    id: json["id"],
    attributes: json["attributes"] == null ? null : DataAttributes.fromMap(json["attributes"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "attributes": attributes?.toMap(),
  };
}

class DataAttributes {
  final String? name;
  final String? alternativeText;
  final String? caption;
  final dynamic width;
  final dynamic height;
  final dynamic formats;
  final String? hash;
  final String? ext;
  final String? mime;
  final double? size;
  final String? url;
  final dynamic previewUrl;
  final String? provider;
  final dynamic providerMetadata;
  final String? folderPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DataAttributes({
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.previewUrl,
    this.provider,
    this.providerMetadata,
    this.folderPath,
    this.createdAt,
    this.updatedAt,
  });

  factory DataAttributes.fromMap(Map<String, dynamic> json) => DataAttributes(
    name: json["name"],
    alternativeText: json["alternativeText"],
    caption: json["caption"],
    width: json["width"],
    height: json["height"],
    formats: json["formats"],
    hash: json["hash"],
    ext: json["ext"],
    mime: json["mime"],
    size: json["size"]?.toDouble(),
    url: json["url"],
    previewUrl: json["previewUrl"],
    provider: json["provider"],
    providerMetadata: json["provider_metadata"],
    folderPath: json["folderPath"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "alternativeText": alternativeText,
    "caption": caption,
    "width": width,
    "height": height,
    "formats": formats,
    "hash": hash,
    "ext": ext,
    "mime": mime,
    "size": size,
    "url": url,
    "previewUrl": previewUrl,
    "provider": provider,
    "provider_metadata": providerMetadata,
    "folderPath": folderPath,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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