// To parse this JSON data, do
//
//     final usuarioAsseweb = usuarioAssewebFromMap(jsonString);

import 'dart:convert';

class UsuarioAsseweb {
  UsuarioAsseweb({
    this.login,
    this.token,
  });

  Login? login;
  String? token;

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
  Login({
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

  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? ddd;
  String? password;
  DateTime? lastAcess;
  DateTime? birthday;
  String? version;
  dynamic resignation;
  String? uid;
  bool? master;
  int? lastCompanyId;
  List<Company>? companies;

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
  Company({
    this.id,
    this.number,
    this.name,
    this.fantasyName,
    this.cnpj,
    this.conntacts,
  });

  int? id;
  int? number;
  String? name;
  String? fantasyName;
  String? cnpj;
  dynamic conntacts;

  factory Company.fromJson(String str) => Company.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Company.fromMap(Map<String, dynamic> json) => Company(
    id: json["id"],
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
