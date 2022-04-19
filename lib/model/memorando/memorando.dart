
class Memorandos {
  DateTime? dataSolicitacao;
  String? horaSolicitacao;
  DateTime? data;
  String? descricao;
  int? status;

  Memorandos({this.dataSolicitacao, this.data, this.descricao, this.status});

  Memorandos.fromMap(Map map) {
    List _d = map["Data"].split("/");
    this.data = DateTime(int.parse(_d[2]), int.parse(_d[1]), int.parse(_d[0]));
    List _s = map["DataSolicitacao"].split(" ");
    List _i = _s[0].split("/");
    this.dataSolicitacao = DateTime(int.parse(_i[2]), int.parse(_i[1]), int.parse(_i[0]));
    this.horaSolicitacao =  _s[1];
    this.descricao = map["Descricao"];
    this.status = int.parse(map["Status"].toString());
  }
}