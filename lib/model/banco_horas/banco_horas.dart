

class BancoHoras {
  DateTime? data;
  String? credito;
  int? creditomin;
  String? debito;
  int? debitomin;
  String? saldo;
  String? saldodia;
  String? descricao;


  BancoHoras(
      {this.data,
      this.credito,
      this.creditomin,
      this.debito,
      this.debitomin,
      this.saldo,
      this.saldodia,
      this.descricao});

  BancoHoras.fromMap(Map map) {
    List _i = map["Data"] == null ? null : map["Data"].split("/");
    this.data = _i == null ? null : DateTime(int.parse(_i[2]), int.parse(_i[1]), int.parse(_i[0]));
    this.credito = map["Credito"] == null ? null : map["Credito"];
    this.creditomin = map["Credito"] == null ? 0 : getmin( map["Credito"]?.toString());
    this.debito = map["Debito"] == null ? null : map["Debito"]?.toString().replaceAll(":-", ":");
    this.debitomin = map["Debito"] == null ? 0 : getmin( map["Debito"]?.toString().replaceAll("-", "") );
    this.saldo = map["Saldo"] == null ? null : map["Saldo"]?.toString().replaceAll(":-", ":");
    this.saldodia = gethoras(this.creditomin ?? 0, this.debitomin ?? 0);
    this.descricao = map["Descricao"] == null ? null : map["Descricao"];
  }

  int getmin(String? horas){
    int valor = 0 ;
    if(horas != null){
      List  _l = horas.split(':');
      valor = (int.parse(_l[0]) * 60) + int.parse(_l[1]);
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
}