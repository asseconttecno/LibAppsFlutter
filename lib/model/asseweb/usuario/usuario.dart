// To parse this JSON data, do
//
//     final usuarioAsseweb = usuarioAssewebFromMap(jsonString);

import 'dart:convert';

import '../../../enums/regime_empresa.dart';
import '../contatos/contatos.dart';

class UsuarioAsseweb {
  const UsuarioAsseweb({
    this.login,
    this.token,
  });

  final Login? login;
  final String? token;

  factory UsuarioAsseweb.fromJson(String str) => UsuarioAsseweb.fromMap(json.decode(str));

  factory UsuarioAsseweb.fromMap(Map<String, dynamic> json) => UsuarioAsseweb(
    login: json["login"] == null ? null : Login.fromMap(json["login"]),
    token: json["token"],
  );
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
  final DateTime? resignation;
  final String? uid;
  final bool? master;
  final int? lastCompanyId;
  final List<Company>? companies;

  factory Login.fromJson(String str) => Login.fromMap(json.decode(str));

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

}

class Company {
  const Company({
    this.id,
    this.number,
    this.name,
    this.fantasyName,
    this.inicio,
    this.cnpj,
    this.conntacts,
    this.regime = RegimeEmpresa.Outras
  });

  final int? id;
  final int? number;
  final String? name;
  final String? fantasyName;
  final String? cnpj;
  final DateTime? inicio;
  final List<ContatosAsseweb>? conntacts;
  final RegimeEmpresa regime;

  factory Company.fromJson(String str) => Company.fromMap(json.decode(str));

  factory Company.fromMap(Map<String, dynamic> json) => Company(
    id: json["id"],
    regime: RegimeEmpresa.getEnum(json["classificacao"]),
    inicio: json["inicio"] == null ? null : DateTime.parse(json["inicio"]),
    number: json["number"],
    name: json["name"],
    fantasyName: json["fantasyName"],
    cnpj: json["cnpj"],
    conntacts: json["conntacts"] == null ? [] : List<ContatosAsseweb>.from(json["conntacts"]!.map((x) => ContatosAsseweb.fromMap(x))),
  );
}
