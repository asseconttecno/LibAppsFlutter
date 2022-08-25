
import '../../model.dart';
import '../apontamento/apontamento.dart';

class UsuarioPonto {
  int? userId;
  String? email;
  String? registro;
  int? database;
  String? funcionarioCpf;
  String? cnpj;
  String? nome;
  String? image;
  String? cargo;
  String? faceid;
  Apontamento? aponta;
  bool? permitirMarcarPonto;
  bool? permitirLocalizacao;
  bool? permitirMarcarPontoOffline;
  bool? master;

  UsuarioPonto(
      {this.userId,
      this.email,
      this.database,
      this.funcionarioCpf,
      this.faceid,
      this.cnpj,
      this.nome,
      this.image,
      this.cargo,
      this.aponta,
      this.permitirMarcarPonto,
      this.permitirLocalizacao,
      this.permitirMarcarPontoOffline,
      this.registro,
      this.master
      });

  UsuarioPonto copyWith({
        String? nome, String? cargo, bool? perm, bool? offline, bool? local, Apontamento? aponta
      }) => UsuarioPonto(
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


  UsuarioPonto.fromMap(Map map, bool sql, {Apontamento? aponta}){
    if(sql){
      this.userId =  map['userId'];
      this.email =  map['email'] ?? '';
      this.database =  map['database'];
      this.funcionarioCpf =  map['funcionarioCpf'] ?? '';
      this.cnpj =  map['cnpj'] ?? '';
      this.nome = map['nome'] ?? '';
      this.cargo = map['cargo'] ?? '';
      this.registro = map['registro'] ?? '';
      this.permitirMarcarPonto = map['permitirMarcarPonto'].toString() == 'true';
      this.permitirMarcarPontoOffline = map['permitirMarcarPontoOffline'] .toString()== 'true';
      this.permitirLocalizacao = map['permitirLocalizacao'].toString() == 'true';
      this.master = map['master'].toString() == 'true';
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


  UsuarioPonto.fromMapTab(Map map, String cod) {
    print('ok from');
    this.userId =  (int?.parse(map["Id"].toString()));
    this.nome = map["Nome"];
    this.cargo = map["Cargo"];
    this.image = map["IdFoto"];
    this.cnpj = map["Cnpj"];
    this.registro = cod;
  }

  UsuarioPonto.fromOff(UserPontoOffine user) {
    this.userId =  user.id!;
    this.nome = user.nome!;
    this.cargo = ' ';
    this.registro = user.registro!;
  }

  Map toMapTab() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "img" : this.image,
      "cargo" : this.cargo,
      "codigo" : this.registro,
      "cnpj" : this.cnpj
    };

    if (this.userId != null) {
      map["id"] = this.userId;
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