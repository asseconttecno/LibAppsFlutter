// To parse this JSON data, do
//
//     final usuarioAsseweb = usuarioAssewebFromMap(jsonString);

import 'dart:convert';

import '../../../enums/regime_empresa.dart';

class UsuarioAsseweb {
  const UsuarioAsseweb({
    this.login,
    this.token,
  });

  final Login? login;
  final String? token;

  factory UsuarioAsseweb.fromJson(String str) => UsuarioAsseweb.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsuarioAsseweb.fromMap(Map<String, dynamic> json) => UsuarioAsseweb(
    login: json["login"] == null ? null : Login.fromMap(json["login"]),
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "login": login?.toMap(),
    "token": token,
  };
}

class Login {
  const Login({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.ddd,
    this.password,
    this.lastAcess,
    this.birthday,
    this.version,
    this.resignation,
    this.uid,
    this.master,
    this.lastCompanyId,
    this.companies,

  });

  final int? id;

  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? ddd;
  final String? password;
  final DateTime? lastAcess;
  final DateTime? birthday;
  final String? version;
  final dynamic resignation;
  final String? uid;
  final bool? master;
  final int? lastCompanyId;
  final List<Company>? companies;

  factory Login.fromJson(String str) => Login.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Login.fromMap(Map<String, dynamic> json) => Login(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    ddd: json["ddd"],
    password: json["password"],
    lastAcess: json["lastAcess"] == null ? null : DateTime.parse(json["lastAcess"]),
    birthday: json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
    version: json["version"],
    resignation: json["resignation"],
    uid: json["uid"],
    master: json["master"],
    lastCompanyId: json["lastCompanyId"],
    companies: json["companies"] == null ? [] : List<Company>.from(json["companies"]!.map((x) => Company.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "ddd": ddd,
    "password": password,
    "lastAcess": lastAcess?.toIso8601String(),
    "birthday": birthday,
    "version": version,
    "resignation": resignation,
    "uid": uid,
    "master": master,
    "lastCompanyId": lastCompanyId,
    "companies": companies == null ? [] : List<dynamic>.from(companies!.map((x) => x.toMap())),
  };
}

class Company {
  const Company({
    this.id,
    this.number,
    this.name,
    this.fantasyName,
    this.cnpj,
    this.conntacts,
    this.regime = RegimeEmpresa.Outras
  });

  final int? id;
  final int? number;
  final String? name;
  final String? fantasyName;
  final String? cnpj;
  final dynamic conntacts;
  final RegimeEmpresa regime;

  factory Company.fromJson(String str) => Company.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Company.fromMap(Map<String, dynamic> json) => Company(
    id: json["id"],
    regime: RegimeEmpresa.getEnum(json["regime"]),
    number: json["number"],
    name: json["name"],
    fantasyName: json["fantasyName"],
    cnpj: json["cnpj"],
    conntacts: json["conntacts"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "number": number,
    "name": name,
    "fantasyName": fantasyName,
    "cnpj": cnpj,
    "conntacts": conntacts,
  };
}
