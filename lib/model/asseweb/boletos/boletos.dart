// To parse this JSON data, do
//
//     final boletosModel = boletosModelFromMap(jsonString);

import 'dart:convert';

import '../../../utils/validacoes.dart';
import '../../../enums/status_boleto.dart';


class BoletosModel {
  BoletosModel({
    this.numero,
    this.dataVencimento,
    this.valor,
    this.status,
    this.url,
  });

  String? numero;
  DateTime? dataVencimento;
  double? valor;
  StatusBoleto? status;
  String? url;

  factory BoletosModel.fromJson(String str) => BoletosModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BoletosModel.fromMap(Map<String, dynamic> json) => BoletosModel(
    numero: json["Numero"],
    dataVencimento: json["DataVencimento"] == null ? null : Validacoes.stringToDataBr(json["DataVencimento"]),
    valor: json["Valor"],
    status: json["Status"] == null ? null : StatusBoleto.getEnum(json["Status"]),
    url: json["Url"],
  );

  Map<String, dynamic> toMap() => {
    "Numero": numero,
    "DataVencimento": dataVencimento,
    "Valor": valor,
    "Status": status,
    "Url": url,
  };
}
