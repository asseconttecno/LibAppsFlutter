
// To parse this JSON data, do
//
//     final bancoHoras = bancoHorasFromMap(jsonString);

import 'dart:convert';

class BancoHoras {
  DateTime? dataInicial;
  DateTime? dataFinal;
  List<BancoDiasList>? bancoDiasList;

  BancoHoras({
    this.dataInicial,
    this.dataFinal,
    this.bancoDiasList,
  });

  factory BancoHoras.fromJson(String str) => BancoHoras.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BancoHoras.fromMap(Map<String, dynamic> json) => BancoHoras(
    dataInicial: json["DataInicial"] == null ? null : DateTime.parse(json["DataInicial"]),
    dataFinal: json["DataFinal"] == null ? null : DateTime.parse(json["DataFinal"]),
    bancoDiasList: json["BancoDiasList"] == null ? [] : List<BancoDiasList>.from(json["BancoDiasList"]!.map((x) => BancoDiasList.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "DataInicial": dataInicial?.toIso8601String(),
    "DataFinal": dataFinal?.toIso8601String(),
    "BancoDiasList": bancoDiasList == null ? [] : List<dynamic>.from(bancoDiasList!.map((x) => x.toMap())),
  };
}

class BancoDiasList {
  DateTime? data;
  String? credito;
  String? descricaoCredito;
  String? debito;
  String? descricaoDebito;
  String? lancamentos;
  String? descricaoLancamentos;
  String? saldo;
  int get creditomin => getmin(credito);
  int get debitomin => getmin(debito);
  String get saldodia => gethoras(creditomin, debitomin);


  BancoDiasList({
    this.data,
    this.credito,
    this.descricaoCredito,
    this.debito,
    this.descricaoDebito,
    this.lancamentos,
    this.descricaoLancamentos,
    this.saldo,
  });

  factory BancoDiasList.fromJson(String str) => BancoDiasList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BancoDiasList.fromMap(Map<String, dynamic> json) => BancoDiasList(
    data: json["Data"] == null ? null : DateTime.parse(json["Data"]),
    credito: json["Credito"]?.toString().trim(),
    descricaoCredito: json["DescricaoCredito"]?.toString().trim(),
    debito: json["Debito"]?.toString().trim(),
    descricaoDebito: json["DescricaoDebito"]?.toString().trim(),
    lancamentos: json["Lancamentos"]?.toString().trim(),
    descricaoLancamentos: json["DescricaoLancamentos"]?.toString().trim(),
    saldo: json["Saldo"]?.toString().trim(),
  );

  int getmin(String? horas){
    int valor = 0 ;
    if(horas != null && horas != '' ){
      List  _l = horas.replaceAll('-', '').split(':');
      if(_l.length > 1){
        valor = (int.parse(_l[0]) * 60) + int.parse(_l[1]);
      }
    }
    return valor;
  }

  String gethoras(int credito, int debito){
    String valor = '0:00' ;

    if(credito > 0 || debito > 0){
      int horas = 0;
      int min = 0;
      int _saldo = credito - debito;
      String sinal = '';
      if(_saldo < 0){
        sinal = '-';
        _saldo = int.tryParse(_saldo.toString().replaceAll('-', '')) ?? 0;
      }
      while(_saldo >= 60){
        horas ++;
        _saldo -= 60;
      }
      min = _saldo;
      valor = '$sinal${horas.toString().padLeft(1,'0')}:${min.toString().padRight(2,'0')}';
    }
    return valor;
  }

  Map<String, dynamic> toMap() => {
    "Data": data?.toIso8601String(),
    "Credito": credito,
    "DescricaoCredito": descricaoCredito,
    "Debito": debito,
    "DescricaoDebito": descricaoDebito,
    "Saldo": saldo,
  };
}