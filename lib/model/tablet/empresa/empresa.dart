

class EmpresaPontoModel {
  String? nome;
  String? cnpj ;
  int? database ;
  String? email;
  String? senha;
  bool? ativado;

  EmpresaPontoModel.user({this.nome, this.database, this.cnpj, this.senha, this.email, this.ativado});

  EmpresaPontoModel.fromJson(Map map, String senha, String email) {
    this.nome = map["Nome"];
    this.database = map["Database"];
    this.cnpj = map["Cnpj"];
    this.ativado = map["Tablet"].toString() == 'true';
    this.email = email;
    this.senha = senha;
  }

  EmpresaPontoModel.fromSql(Map map) {
    this.nome = map["nome"];
    this.database = map["database"];
    this.cnpj = map["cnpj"];
    this.email = map["email"];
    this.senha = map["senha"];
    this.ativado = map["ativado"].toString() == 'true';
  }

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      "nome": this.nome,
      "database": this.database,
      "cnpj": this.cnpj,
      "email": this.email,
      "senha": this.senha,
      "ativado": this.ativado.toString(),
    };
    return map;
  }
}