import 'dart:convert';

import 'package:assecontservices/assecontservices.dart';

import '../../tablet/usuario/user_offiline.dart';

class UsuarioPonto {
  int? databaseId;
  bool? app;
  Periodo? periodo;
  Funcionario? funcionario;

  UsuarioPonto({
    this.databaseId,
    this.app,
    this.periodo,
    this.funcionario,
  });

  factory UsuarioPonto.fromMap(Map<String, dynamic> json, bool sql) {
    UsuarioPonto user;
    if(sql){
      user = UsuarioPonto(
        databaseId: json['database'],
        app: json['master'].toString() == 'true',
        periodo: Periodo(
          dataFinal: json['datatermino'],
          dataInicial: json['datainicio'],
          descricao: json['apontamento']
        ),
        funcionario: Funcionario(
          funcionarioId: json['userId'],
          nome: json['nome'],
          registro: json['registro'],
          cpf: json['funcionarioCpf'],
          cnpj: json['cnpj'],
          cargo: json['cargo'],
          permitirMarcarPonto: json['permitirMarcarPonto'].toString() == 'true',
          permitirMarcarPontoOffline: json['permitirMarcarPontoOffline'].toString()== 'true',
          capturarGps: json['permitirLocalizacao'].toString() == 'true',
        ),
      );
    }else{
      user = UsuarioPonto(
        databaseId: json["DatabaseId"],
        app: json["App"],
        periodo: json["Periodo"] == null ? null : Periodo.fromMap(json["Periodo"]),
        funcionario: json["Funcionario"] == null ? null : Funcionario.fromMap(json["Funcionario"]),
      );
    }
    return user;
  }

  factory UsuarioPonto.fromMapTab(Map map, String cod) {

    return UsuarioPonto(
      periodo: Periodo(
          dataFinal: Apontamento.padrao().datatermino,
          dataInicial: Apontamento.padrao().datainicio,
          descricao: Apontamento.padrao().descricao
      ),
      funcionario: Funcionario(
        funcionarioId: (int.tryParse(map["Id"].toString())),
        nome: map["Nome"],
        registro: cod,
        foto: map["IdFoto"],
        cnpj: map["Cnpj"],
        cargo: map["Cargo"],
      ),
    );
  }

  factory UsuarioPonto.fromOff(UserPontoOffine user) {

    return UsuarioPonto(
      periodo: Periodo(
          dataFinal: Apontamento.padrao().datatermino,
          dataInicial: Apontamento.padrao().datainicio,
          descricao: Apontamento.padrao().descricao
      ),
      funcionario: Funcionario(
        funcionarioId: user.id!,
        nome: user.nome!,
        registro: user.registro!,
        cargo: '',
      ),
    );
  }

  Map toMapTab() {
    Map<String, dynamic> map = {
      "nome": funcionario?.nome,
      "img" : null,
      "cargo" : funcionario?.cargo,
      "codigo" : funcionario?.registro,
      "userId" : funcionario?.funcionarioId,
      "cnpj" : funcionario?.cnpj
    };
    return map;
  }

  Map<String, dynamic> toMap(){
    return {
      'userId': funcionario?.funcionarioId,
      'database': databaseId,
      'nome': funcionario?.nome,
      'email': funcionario?.email,
      'pis': funcionario?.pis,
      'funcionarioCpf': funcionario?.cpf,
      'registro': funcionario?.registro,
      'cnpj': funcionario?.cnpj,
      'master': app.toString(),
      'connected': 'true',
      'cargo': funcionario?.cargo,
      'apontamento': periodo?.descricao ?? Apontamento.padrao().descricao,
      'datainicio': periodo?.dataInicial == null ? Apontamento.padrao().datainicio
          : DateFormat('yyyy-MM-dd').format(periodo!.dataInicial!) ,
      'datatermino': periodo?.dataFinal == null ? Apontamento.padrao().datatermino
          : DateFormat('yyyy-MM-dd').format(periodo!.dataFinal!),
      'permitirMarcarPonto': funcionario?.permitirMarcarPonto.toString(),
      'permitirMarcarPontoOffline': funcionario?.permitirMarcarPontoOffline.toString(),
      'permitirLocalizacao': funcionario?.capturarGps.toString(),
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
  String? email;
  String? pis;
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
    this.email,
    this.pis,
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

  factory Funcionario.fromMap(Map<String, dynamic> json) => Funcionario(
    funcionarioId: json["FuncionarioId"],
    nome: json["Nome"],
    registro: json["Registro"],
    cpf: json["CPF"],
    email: json["email"],
    pis: json["pis"],
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
