import 'dart:convert';

class UsuarioPonto {
  int? databaseId;
  bool? app;
  String? email;
  StatusLogin? statusLogin;
  Periodo? periodo;
  Funcionario? funcionario;

  UsuarioPonto({
    this.databaseId,
    this.app,
    this.email,
    this.statusLogin,
    this.periodo,
    this.funcionario,
  });

  factory UsuarioPonto.fromMap(Map<String, dynamic> json, String? email, bool sql) {
    UsuarioPonto user;
    if(sql){
      user = UsuarioPonto(
        databaseId: json['database''userId'],
        app: json['master'].toString() == 'true',
        email: json['email'] ?? '',
        periodo: json["Periodo"] == null ? null : Periodo.fromMap(json["Periodo"]),
        funcionario: json["Funcionario"] == null ? null : Funcionario(
          capturarGps: json['permitirLocalizacao'].toString() == 'true',
          cargo: json['cargo'] ?? '',
          nome: json['nome'] ?? '',
          cnpj: json['cnpj'] ?? '',
          registro: json['registro'] ?? '',
          permitirMarcarPonto: json['permitirMarcarPonto'].toString() == 'true',
          permitirMarcarPontoOffline: json['permitirMarcarPontoOffline'] .toString()== 'true',
        ),
      );
    }else{
      user = UsuarioPonto(
        databaseId: json["DatabaseId"],
        app: json["App"],
        email: email,
        statusLogin: json["StatusLogin"] == null ? null : StatusLogin.fromMap(json["StatusLogin"]),
        periodo: json["Periodo"] == null ? null : Periodo.fromMap(json["Periodo"]),
        funcionario: json["Funcionario"] == null ? null : Funcionario.fromMap(json["Funcionario"]),
      );
    }
    return user;
  }

  Map toMapTab() {
    Map<String, dynamic> map = {
      "nome": nome,
      "img" : image,
      "cargo" : cargo,
      "codigo" : registro,
      "cnpj" : cnpj
    };

    if (userId != null) {
      map["id"] = userId;
    }

    return map;
  }

  Map<String, dynamic> toMap(){
    return {
      'userId': userId,
      'email': email,
      'database': database,
      'master': master.toString(),
      'funcionarioCpf': funcionarioCpf,
      'cnpj': cnpj,
      'nome': nome,
      'cargo': cargo,
      'registro': registro,
      'apontamento': aponta?.descricao,
      'datainicio': aponta?.datainicio.toString(),
      'datatermino': aponta?.datatermino.toString(),
      'permitirMarcarPonto': permitirMarcarPonto.toString(),
      'permitirLocalizacao': permitirLocalizacao.toString(),
      'permitirMarcarPontoOffline': permitirMarcarPontoOffline.toString(),
    };
  }
}

class Funcionario {
  int? funcionarioId;
  String? nome;
  String? registro;
  String? cpf;
  String? cargo;
  String? foto;
  bool? permitirMarcarPontoWeb;
  bool? permitirMarcarPonto;
  bool? permitirMarcarPontoOffline;
  bool? capturarGps;
  DateTime? ultimaMarcacao;
  int? setorId;
  String? cnpj;

  Funcionario({
    this.funcionarioId,
    this.nome,
    this.registro,
    this.cpf,
    this.cargo,
    this.foto,
    this.permitirMarcarPontoWeb,
    this.permitirMarcarPonto,
    this.permitirMarcarPontoOffline,
    this.capturarGps,
    this.ultimaMarcacao,
    this.setorId,
    this.cnpj,
  });

  factory Funcionario.fromJson(String str) => Funcionario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Funcionario.fromMap(Map<String, dynamic> json) => Funcionario(
    funcionarioId: json["FuncionarioId"],
    nome: json["Nome"],
    registro: json["Registro"],
    cpf: json["CPF"],
    cargo: json["Cargo"],
    foto: json["Foto"],
    permitirMarcarPontoWeb: json["PermitirMarcarPontoWeb"],
    permitirMarcarPonto: json["PermitirMarcarPonto"],
    permitirMarcarPontoOffline: json["PermitirMarcarPontoOffline"],
    capturarGps: json["CapturarGps"],
    ultimaMarcacao: json["UltimaMarcacao"] == null ? null : DateTime.parse(json["UltimaMarcacao"]),
    setorId: json["SetorId"],
    cnpj: json["CNPJ"],
  );

  Map<String, dynamic> toMap() => {
    "FuncionarioId": funcionarioId,
    "Nome": nome,
    "Registro": registro,
    "CPF": cpf,
    "Cargo": cargo,
    "Foto": foto,
    "PermitirMarcarPontoWeb": permitirMarcarPontoWeb,
    "PermitirMarcarPonto": permitirMarcarPonto,
    "PermitirMarcarPontoOffline": permitirMarcarPontoOffline,
    "CapturarGps": capturarGps,
    "UltimaMarcacao": ultimaMarcacao?.toIso8601String(),
    "SetorId": setorId,
    "CNPJ": cnpj,
  };
}

class Periodo {
  DateTime? dataInicial;
  DateTime? dataFinal;
  String? descricao;

  Periodo({
    this.dataInicial,
    this.dataFinal,
    this.descricao,
  });

  factory Periodo.fromJson(String str) => Periodo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Periodo.fromMap(Map<String, dynamic> json) => Periodo(
    dataInicial: json["DataInicial"] == null ? null : DateTime.parse(json["DataInicial"]),
    dataFinal: json["DataFinal"] == null ? null : DateTime.parse(json["DataFinal"]),
    descricao: json["Descricao"],
  );

  Map<String, dynamic> toMap() => {
    "DataInicial": dataInicial?.toIso8601String(),
    "DataFinal": dataFinal?.toIso8601String(),
    "Descricao": descricao,
  };
}

class StatusLogin {
  int? status;
  String? descricao;

  StatusLogin({
    this.status,
    this.descricao,
  });

  factory StatusLogin.fromJson(String str) => StatusLogin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StatusLogin.fromMap(Map<String, dynamic> json) => StatusLogin(
    status: json["Status"],
    descricao: json["Descricao"],
  );

  Map<String, dynamic> toMap() => {
    "Status": status,
    "Descricao": descricao,
  };
}
