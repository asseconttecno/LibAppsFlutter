

import '../../model.dart';


class UsuarioHoleriteModel {
  String? jwt;
  UserHolerite? user;

  UsuarioHoleriteModel({
    this.jwt,
    this.user,
  });

  UsuarioHoleriteModel copyWith({
    UsuarioHoleriteModel? user,
  }) =>
      UsuarioHoleriteModel(
        jwt: user?.jwt ?? this.jwt,
        user: this.user == null ? user?.user : this.user?.copyWith(
          id: user?.user?.id,
          username: user?.user?.username,
          email: user?.user?.email,
          provider: user?.user?.provider,
          confirmed: user?.user?.confirmed,
          blocked: user?.user?.blocked,
          cpf: user?.user?.cpf,
          fantasyName: user?.user?.fantasyName,
          enterpriseName: user?.user?.enterpriseName,
          phone: user?.user?.phone,
          stateRegistration: user?.user?.stateRegistration,
          createdAt: user?.user?.createdAt,
          updatedAt: user?.user?.updatedAt,
          name: user?.user?.name,
          office: user?.user?.office,
          department: user?.user?.department,
          isManager: user?.user?.isManager,
        ),
      );

  factory UsuarioHoleriteModel.fromMap(Map<String, dynamic> json) => UsuarioHoleriteModel(
    jwt: json["jwt"],
    user: json["user"] == null ? null : UserHolerite.fromMap(json["user"]),
  );

  Map<String, dynamic> toMap() => {
    "jwt": jwt,
    "user": user?.toMap(),
  };
}

class UserHolerite {
  int? id;
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  String? cpf;
  String? fantasyName;
  String? enterpriseName;
  String? phone;
  String? stateRegistration;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? office;
  String? department;
  bool? isManager;

  UserHolerite({
    this.id,
    this.username,
    this.email,
    this.provider,
    this.confirmed,
    this.blocked,
    this.cpf,
    this.fantasyName,
    this.enterpriseName,
    this.phone,
    this.stateRegistration,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.office,
    this.department,
    this.isManager,
  });

  UserHolerite copyWith({
    int? id,
    String? username,
    String? email,
    String? provider,
    bool? confirmed,
    bool? blocked,
    String? cpf,
    String? fantasyName,
    String? enterpriseName,
    String? phone,
    String? stateRegistration,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? office,
    String? department,
    bool? isManager,
  }) =>
      UserHolerite(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        provider: provider ?? this.provider,
        confirmed: confirmed ?? this.confirmed,
        blocked: blocked ?? this.blocked,
        cpf: cpf ?? this.cpf,
        fantasyName: fantasyName ?? this.fantasyName,
        enterpriseName: enterpriseName ?? this.enterpriseName,
        phone: phone ?? this.phone,
        stateRegistration: stateRegistration ?? this.stateRegistration,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        office: office ?? this.office,
        department: department ?? this.department,
        isManager: isManager ?? this.isManager,
      );

  factory UserHolerite.fromMap(Map<String, dynamic> json) => UserHolerite(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    provider: json["provider"],
    confirmed: json["confirmed"],
    blocked: json["blocked"],
    cpf: json["cpf"] ?? '373.771.848-25',
    fantasyName: json["fantasyName"],
    enterpriseName: json["enterpriseName"],
    phone: json["phone"],
    stateRegistration: json["stateRegistration"],
    createdAt: json["createdAt"] == null ? null : DateTime.tryParse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.tryParse(json["updatedAt"]),
    name: json["name"],
    office: json["office"],
    department: json["department"],
    isManager: json["isManager"],
  );

  UserHolerite.fromPonto(UsuarioPonto user){
    this.email = user.funcionario?.email;
    this.name = user.funcionario?.nome;
    this.cpf = user.funcionario?.cpf;
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "username": username,
    "email": email,
    "provider": provider,
    "confirmed": confirmed,
    "blocked": blocked,
    "cpf": cpf,
    "fantasyName": fantasyName,
    "enterpriseName": enterpriseName,
    "phone": phone,
    "stateRegistration": stateRegistration,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "name": name,
    "office": office,
    "department": department,
    "isManager": isManager,
  };
}
