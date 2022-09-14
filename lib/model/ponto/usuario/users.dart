
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
          userId: userId ?? userId,
          email: email ?? email,
          database: database ?? database,
          funcionarioCpf: funcionarioCpf ?? funcionarioCpf,
          faceid: faceid ?? faceid,
          cnpj: cnpj ?? cnpj,
          nome: nome ?? this.nome,
          cargo: cargo ?? this.cargo,
          aponta: aponta ?? this.aponta,
          permitirMarcarPonto: perm ?? permitirMarcarPonto,
          permitirLocalizacao: local ?? permitirLocalizacao,
          permitirMarcarPontoOffline: offline ?? permitirMarcarPontoOffline,
          registro: registro ?? registro,
          master: master ?? master
      );


  UsuarioPonto.fromMap(Map map, bool sql, {Apontamento? aponta}){
    if(sql){
      userId =  map['userId'];
      email =  map['email'] ?? '';
      database =  map['database'];
      funcionarioCpf =  map['funcionarioCpf'] ?? '';
      cnpj =  map['cnpj'] ?? '';
      nome = map['nome'] ?? '';
      cargo = map['cargo'] ?? '';
      registro = map['registro'] ?? '';
      permitirMarcarPonto = map['permitirMarcarPonto'].toString() == 'true';
      permitirMarcarPontoOffline = map['permitirMarcarPontoOffline'] .toString()== 'true';
      permitirLocalizacao = map['permitirLocalizacao'].toString() == 'true';
      master = map['master'].toString() == 'true';
      this.aponta = Apontamento.aponta(datainicio: DateTime.parse(map['datainicio']),
          datatermino: DateTime.parse(map['datatermino']), descricao: map['apontamento']);
    }else{
      userId =   map["UserId"];
      email = map["Email"];
      database = map["Database"];
      master = map['App'].toString() == 'true';
      if(map['Funcionario'] != null){
        funcionarioCpf = map['Funcionario']['FuncionarioCpf'];
        cnpj = map['Funcionario']['Cnpj']['Numero'];
        registro = map['Funcionario']['Registro'];
      }
      this.aponta = aponta;
      faceid = map["IdFoto"];
    }
  }


  UsuarioPonto.fromMapTab(Map map, String cod) {
    print('ok from');
    userId =  (int?.parse(map["Id"].toString()));
    nome = map["Nome"];
    cargo = map["Cargo"];
    image = map["IdFoto"];
    cnpj = map["Cnpj"];
    registro = cod;
  }

  UsuarioPonto.fromOff(UserPontoOffine user) {
    userId =  user.id!;
    nome = user.nome!;
    cargo = ' ';
    registro = user.registro!;
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