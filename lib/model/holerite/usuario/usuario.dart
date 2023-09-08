

import '../../model.dart';

class UsuarioHolerite {
  int? id;
  String? nome;
  String? empresa;
  String? cnpj;
  String? registro;
  String? cpf;
  String? email;
  String? ddd;
  String? celular;

  UsuarioHolerite({this.id, this.nome, this.empresa, this.email, this.cnpj, this.cpf, this.registro, this.ddd, this.celular});

  UsuarioHolerite copyWith({
    String? email, String? nome, String? empresa, String? cpf, String? cnpj, String? registro, String? celular
  }) => UsuarioHolerite(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      empresa: empresa ?? this.empresa,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      cnpj: cnpj ?? this.cnpj,
      registro: registro ?? this.registro,
      ddd: ddd ?? this.ddd,
      celular: celular ?? this.celular
  );

  UsuarioHolerite.fromMap(Map map){
    this.id =   map["id"] == null ? null : map["id"];
    this.email = map["email"] == null ? null : map["email"];
    this.empresa = map["empresa"] == null ? null : map["empresa"];
    this.nome = map["nome"] == null ? null : map["nome"];
    this.cpf = map["cpf"] == null ? null : map["cpf"];
    this.cnpj = map["cnpj"] == null ? null : map["cnpj"];
    this.registro = map["registro"] == null ? null : map["registro"];
    this.ddd = map["ddd"] == null ? null : map["ddd"];
    this.celular = map["celular"] == null ? null : map["celular"];
  }

  UsuarioHolerite.fromPonto(UsuarioPonto user){
    this.id = user.funcionario?.funcionarioId;
    this.email = user.funcionario?.email;
    this.nome = user.funcionario?.nome;
    this.cpf = user.funcionario?.cpf;
    this.cnpj = user.funcionario?.cnpj;
    this.registro = user.funcionario?.registro;
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'email': email,
      'empresa': empresa,
      'nome': nome,
      'cpf': cpf,
      'cnpj': cnpj,
      'registro': registro,
      'ddd': ddd,
      'celular': celular,
    };
  }
}