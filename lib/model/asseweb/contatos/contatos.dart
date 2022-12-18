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
  String?role;
  String? email;
  String? phone;
  dynamic cellPhoneDdd;
  String? cellPhone;
  int? sector;
  String? sectorName;

  factory ContatosAsseweb.fromJson(String str) => ContatosAsseweb.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ContatosAsseweb.fromMap(Map<String, dynamic> json) => ContatosAsseweb(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    role: json["role"] == null ? null : json["role"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    cellPhoneDdd: json["cellPhoneDDD"],
    cellPhone: json["cellPhone"] == null ? null : json["cellPhone"],
    sector: json["sector"] == null ? null : json["sector"],
    sectorName: json["sectorName"] == null ? null : json["sectorName"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "role": role == null ? null : role,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "cellPhoneDDD": cellPhoneDdd,
    "cellPhone": cellPhone == null ? null : cellPhone,
    "sector": sector == null ? null : sector,
    "sectorName": sectorName == null ? null : sectorName,
  };
}
