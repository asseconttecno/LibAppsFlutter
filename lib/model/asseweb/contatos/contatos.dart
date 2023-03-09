// To parse this JSON data, do
//
//     final contatosAsseweb = contatosAssewebFromMap(jsonString);

import 'dart:convert';

class ContatosAsseweb {
  ContatosAsseweb({
    this.id,
    this.name,
    this.role,
    this.email,
    this.phone,
    this.cellPhoneDdd,
    this.cellPhone,
    this.sector,
    this.sectorName,
  });

  int? id;
  String? name;
  String? role;
  String? email;
  String? phone;
  String? cellPhoneDdd;
  String? cellPhone;
  int? sector;
  String? sectorName;

  factory ContatosAsseweb.fromJson(String str) => ContatosAsseweb.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ContatosAsseweb.fromMap(Map<String, dynamic> json) => ContatosAsseweb(
    id: json["id"],
    name: json["name"],
    role: json["role"],
    email: json["email"],
    phone: json["phone"],
    cellPhoneDdd: json["cellPhoneDDD"],
    cellPhone: json["cellPhone"],
    sector: json["sector"],
    sectorName: json["sectorName"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "role": role,
    "email": email,
    "phone": phone,
    "cellPhoneDDD": cellPhoneDdd,
    "cellPhone": cellPhone,
    "sector": sector,
    "sectorName": sectorName,
  };
}
