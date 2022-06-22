

class HistoricoMarcacoesModel{
  String? nome;
  String? cargo;
  DateTime? data;
  String? img;

  HistoricoMarcacoesModel({this.nome, this.cargo, this.data, this.img});

  HistoricoMarcacoesModel.fromMap(Map map){
    this.nome = map['nome'] != null ? map['nome'] : null;
    this.cargo = map['cargo'] != null ? map['cargo'] : null;
    this.data = map['datahora'] != null ? DateTime.tryParse(map['datahora']) : null;
    this.img = map['img'] != null ? map['img'] : null;
  }
}