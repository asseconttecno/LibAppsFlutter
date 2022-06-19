
class UserPontoOffine {
  int? id;
  String? nome;
  String? pis;
  String? registro;

  UserPontoOffine({this.id, this.nome, this.pis, this.registro});

  UserPontoOffine.fromMap(Map map) {
    this.id =  (int?.parse(map["Id"].toString()));
    this.nome = map["Nome"];
    this.pis = map["Pis"];
    this.registro = map["Registro"];
  }

  UserPontoOffine.fromSQL(Map map) {
    this.id =  (int?.parse(map["iduser"].toString()));
    this.nome = map["nome"];
    this.pis = map["pis"];
    this.registro = map["registro"];
  }

  String toMap() {
    String map = '''
      (${this.id},
      '${this.nome}',
      '${this.pis}',
      '${this.registro}')
    ''';
    return map;
  }
}