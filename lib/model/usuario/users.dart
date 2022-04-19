import '../../model/apontamento/apontamento.dart';

class Usuario {
  int? userId;
  String? email;
  String? registro;
  int? database;
  String? funcionarioCpf;
  String? cnpj;
  String? nome;
  String? cargo;
  String? faceid;
  Apontamento? aponta;
  bool? permitirMarcarPonto;
  bool? permitirLocalizacao;
  bool? permitirMarcarPontoOffline;
  bool? master;

  Usuario(
      {this.userId,
      this.email,
      this.database,
      this.funcionarioCpf,
      this.faceid,
      this.cnpj,
      this.nome,
      this.cargo,
      this.aponta,
      this.permitirMarcarPonto,
      this.permitirLocalizacao,
      this.permitirMarcarPontoOffline,
      this.registro,
      this.master
      });

      Usuario copyWith({
        String? nome, String? cargo, bool? perm, bool? offline, bool? local, Apontamento? aponta
      }) => Usuario(
          userId: userId ?? this.userId,
          email: email ?? this.email,
          database: database ?? this.database,
          funcionarioCpf: funcionarioCpf ?? this.funcionarioCpf,
          faceid: faceid ?? this.faceid,
          cnpj: cnpj ?? this.cnpj,
          nome: nome ?? this.nome,
          cargo: cargo ?? this.cargo,
          aponta: aponta ?? this.aponta,
          permitirMarcarPonto: perm ?? this.permitirMarcarPonto,
          permitirLocalizacao: local ?? this.permitirLocalizacao,
          permitirMarcarPontoOffline: offline ?? this.permitirMarcarPontoOffline,
          registro: registro ?? this.registro,
          master: master ?? this.master
      );

  Usuario.fromMap(Map map, bool sql, {Apontamento? aponta}){
    if(sql){
      this.userId =  map['userId'];
      this.email =  map['email'];
      this.database =  map['database'];
      this.funcionarioCpf =  map['funcionarioCpf'] ?? '';
      this.cnpj =  map['cnpj'] ?? '';
      this.nome = map['nome'];
      this.cargo = map['cargo'];
      this.registro = map['registro'];
      this.permitirMarcarPonto = map['permitirMarcarPonto'] == 'true';
      this.permitirMarcarPontoOffline = map['permitirMarcarPontoOffline'] == 'true';
      this.permitirLocalizacao = map['permitirLocalizacao'] == 'true';
      this.master = map['master'] == 'true';
      this.aponta = Apontamento.aponta(datainicio: DateTime.parse(map['datainicio']),
          datatermino: DateTime.parse(map['datatermino']), descricao: map['apontamento']);
    }else{
      this.userId =   map["UserId"] == null ? null : map["UserId"];
      this.email = map["Email"] == null ? null : map["Email"];
      this.database = map["Database"] == null ? null : map["Database"];
      this.master = map['App'].toString() == 'true';
      if(map['Funcionario'] != null){
        this.funcionarioCpf = map['Funcionario']['FuncionarioCpf'];
        this.cnpj = map['Funcionario']['Cnpj']['Numero'];
        this.registro = map['Funcionario']['Registro'];
      }
      this.aponta = aponta;
      this.faceid = map["IdFoto"] == null ? null : map["IdFoto"];
    }
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