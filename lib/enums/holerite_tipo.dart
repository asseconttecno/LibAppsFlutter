

enum HoleriteTipo
{
  Nenhum(0),
  Salario(1),
  ProLabore(2),
  Adiantamento(3),
  PrimeiraDecimo(4),
  SegundaDecimo(5),
  PLR(6),
  Abono(7),
  Domestica(7);

  final int value;

  String get toName {
    switch(value) {
      case 0:
        return 'Recibo';
      case 1:
        return 'Recibo de Salário';
      case 2:
        return 'Recibo de Pró Labore';
      case 3:
        return 'Recibo de Adiantamento';
      case 4:
        return 'Recibo de 1ª Parcela 13º Salário';
      case 5:
        return 'Recibo de 2ª Parcela 13º Salário';
      case 6:
        return 'Participação Remunerada nos Resultados';
      case 7:
        return 'Recibo de Abono';
      case 8:
        return 'Recibo de Domestica';
      default:
        return 'Recibo de Salário';
    }
  }

  static HoleriteTipo getEnum(int? x) {
    switch(x) {
      case 0:
        return Nenhum;
      case 1:
        return Salario;
      case 2:
        return ProLabore;
      case 3:
        return Adiantamento;
      case 4:
        return PrimeiraDecimo;
      case 5:
        return SegundaDecimo;
      case 6:
        return PLR;
      case 7:
        return Abono;
      case 8:
        return Domestica;
      default:
        return Nenhum;
    }
  }

  const HoleriteTipo(this.value);
}