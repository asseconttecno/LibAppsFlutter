
class ResultadoItemList{
  String? descricao;
  String? valor;

  ResultadoItemList(this.descricao, this.valor);

  ResultadoItemList.fromMap(Map map){
    this.descricao = map['Valor'].toString() != 'null' ? map['Valor']['Descricao'] : map['ValorString']['Descricao'];
    this.valor = map['Valor'].toString() != 'null' ?
    map['Valor']['Valor']['Horas'].toString().replaceAll(":-", ":") : map['ValorString']['ValorString'];
  }
}