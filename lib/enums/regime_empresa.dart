

enum RegimeEmpresa {
  Outras(0),
  LucroPresumido(1),
  LucroReal(2),
  Simples(3),
  Imunes(4),
  Mei(5),
  Isenta(6);

  static RegimeEmpresa getEnum(int? x) {
    switch(x) {
      case 0:
        return Outras;
      case 1:
        return LucroPresumido;
      case 2:
        return LucroReal;
      case 3:
        return Simples;
      case 4:
        return Imunes;
      case 5:
        return Mei;
      case 6:
        return Isenta;
      default:
        return Outras;
    }
  }

  final int value;
  const RegimeEmpresa(this.value);
}