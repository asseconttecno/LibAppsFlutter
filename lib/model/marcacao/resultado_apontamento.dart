
class ResultadoApontamento {
  String? trab;
  String? extras;
  int extrasmin = 0;
  String? dsr;
  String? ddsr;
  String? noturno;
  String? abono;
  int abonosmin = 0;
  String? faltas;
  String? descontos;
  int descontosmin = 0;
  String? atrasos;
  int atrasosmin = 0;
  int faltasDias = 0;

  ResultadoApontamento.fromMap(Map map) {
    this.trab = map["Trab"]["Horas"];
    this.extras = map["Extras"]["Horas"];
    this.extrasmin = map["Extras"]["Minutos"];
    this.dsr = map["Dsr"]["Horas"];
    this.ddsr = map["DDsr"]["Horas"];
    this.noturno = map["Noturno"]["Horas"];
    this.abono = map["Abono"]["Horas"];
    this.abonosmin = map["Abono"]["Minutos"];
    this.faltas = map["Faltas"]["Horas"];
    this.descontos = map["Descontos"]["Horas"];
    this.descontosmin = map["Descontos"]["Minutos"];
    this.atrasos = map["Atrasos"]["Horas"];
    this.atrasosmin = map["Atrasos"]["Minutos"];
    this.faltasDias = int.parse(map["FaltasDias"].toString());
  }

}