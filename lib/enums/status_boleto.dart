
enum StatusBoleto {
  ///[Description("")]
  EmAbertoNaoVencido(0),

  ///[Description("Em Aberto")]
  EmAbertoVencido(1),

  ///[Description("Contra-Apresentação")]
  ContraApresentacao(2),

  ///[Description("Pago")]
  Pago(3),

  ///[Description("Boleto não encontrado")]
  NaoEncontrado(4);

  static StatusBoleto getEnum(int x) {
    switch(x) {
      case 1:
        return EmAbertoVencido;
      case 2:
        return ContraApresentacao;
      case 3:
        return Pago;
      case 4:
        return NaoEncontrado;
      case 0:
        return EmAbertoNaoVencido;
      default:
        return EmAbertoNaoVencido;
    }
  }

  String statusNome() {
    switch(value) {
      case 1:
        return "Em Aberto\nVencido";
      case 2:
        return "Contra-Apresentação";
      case 3:
        return "Pago";
      case 4:
        return "Boleto não\nencontrado";
      case 0:
        return "Em Aberto";
      default:
        return "Em Aberto";
    }
  }

  final int value;
  const StatusBoleto(this.value);
}