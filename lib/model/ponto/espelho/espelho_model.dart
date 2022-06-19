import 'dart:io';

class EspelhoModel {
  bool? assinado;
  File? espelho;
  String? espelhoHtml;
  DateTime? data;

  EspelhoModel({this.assinado, this.espelho, this.espelhoHtml, this.data});

  EspelhoModel.fromMap(Map map){
    print(map["dataAssinatura"]);
    this.assinado = map["status"].toString() == 'true';
    this.espelhoHtml = map["espelho"];
    if(map["dataAssinatura"] != '0001-01-01T00:00:00')
      this.data = DateTime.tryParse(map["dataAssinatura"].toString());
  }
}