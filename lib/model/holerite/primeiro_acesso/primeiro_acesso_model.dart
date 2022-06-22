
class PrimeiroAcessoHoleriteModel{
  int? id;
  String? name;
  String? email;

  PrimeiroAcessoHoleriteModel.fromMap(Map map){
    this.id =   map["id"] == null ? null : map["id"];
    this.email = map["email"] == null ? null : map["email"];
    this.name = map["name"] == null ? null : map["name"];
  }
}