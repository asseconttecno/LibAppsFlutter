

class FuncionariosHoleriteModel {
  List<DatumFuncionarios>? data;
  MetaFuncionarios? meta;

  FuncionariosHoleriteModel({
    this.data,
    this.meta,
  });

  FuncionariosHoleriteModel copyWith({
    List<DatumFuncionarios>? data,
    MetaFuncionarios? meta,
  }) =>
      FuncionariosHoleriteModel(
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );

  factory FuncionariosHoleriteModel.fromMap(Map<String, dynamic> json) => FuncionariosHoleriteModel(
    data: json["data"] == null ? [] : List<DatumFuncionarios>.from(json["data"]!.map((x) => DatumFuncionarios.fromMap(x))),
    meta: json["meta"] == null ? null : MetaFuncionarios.fromMap(json["meta"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "meta": meta?.toMap(),
  };
}

class DatumFuncionarios {
  int? id;
  AttributesFuncionarios? attributes;

  DatumFuncionarios({
    this.id,
    this.attributes,
  });

  DatumFuncionarios copyWith({
    int? id,
    AttributesFuncionarios? attributes,
  }) =>
      DatumFuncionarios(
        id: id ?? this.id,
        attributes: attributes ?? this.attributes,
      );

  factory DatumFuncionarios.fromMap(Map<String, dynamic> json) => DatumFuncionarios(
    id: json["id"],
    attributes: json["attributes"] == null ? null : AttributesFuncionarios.fromMap(json["attributes"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "attributes": attributes?.toMap(),
  };
}

class AttributesFuncionarios {
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

  AttributesFuncionarios({
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

  AttributesFuncionarios copyWith({
    String? nome,
    String? cpf,
    String? phone,
    String? email,
    int? baseSalary,
    String? office,
    String? sector,
    String? ctps,
    String? syndicate,
    String? codeBank,
    String? accountBank,
    String? typeBank,
    String? pixKeyBank,
    String? agencyBank,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reg,
    bool? isPreRegistered,
  }) =>
      AttributesFuncionarios(
        nome: nome ?? this.nome,
        cpf: cpf ?? this.cpf,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        baseSalary: baseSalary ?? this.baseSalary,
        office: office ?? this.office,
        sector: sector ?? this.sector,
        ctps: ctps ?? this.ctps,
        syndicate: syndicate ?? this.syndicate,
        codeBank: codeBank ?? this.codeBank,
        accountBank: accountBank ?? this.accountBank,
        typeBank: typeBank ?? this.typeBank,
        pixKeyBank: pixKeyBank ?? this.pixKeyBank,
        agencyBank: agencyBank ?? this.agencyBank,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        reg: reg ?? this.reg,
        isPreRegistered: isPreRegistered ?? this.isPreRegistered,
      );

  factory AttributesFuncionarios.fromMap(Map<String, dynamic> json) => AttributesFuncionarios(
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

class MetaFuncionarios {
  PaginationFuncionarios? pagination;

  MetaFuncionarios({
    this.pagination,
  });

  MetaFuncionarios copyWith({
    PaginationFuncionarios? pagination,
  }) =>
      MetaFuncionarios(
        pagination: pagination ?? this.pagination,
      );

  factory MetaFuncionarios.fromMap(Map<String, dynamic> json) => MetaFuncionarios(
    pagination: json["pagination"] == null ? null : PaginationFuncionarios.fromMap(json["pagination"]),
  );

  Map<String, dynamic> toMap() => {
    "pagination": pagination?.toMap(),
  };
}

class PaginationFuncionarios {
  int? start;
  int? limit;
  int? total;

  PaginationFuncionarios({
    this.start,
    this.limit,
    this.total,
  });

  PaginationFuncionarios copyWith({
    int? start,
    int? limit,
    int? total,
  }) =>
      PaginationFuncionarios(
        start: start ?? this.start,
        limit: limit ?? this.limit,
        total: total ?? this.total,
      );

  factory PaginationFuncionarios.fromMap(Map<String, dynamic> json) => PaginationFuncionarios(
    start: json["start"],
    limit: json["limit"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "start": start,
    "limit": limit,
    "total": total,
  };
}
