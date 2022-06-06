import 'package:intl/intl.dart';

import 'resultado_apontamento.dart';
import '../../services/localizacao.dart';


class Marcacao {
  int? iduser;
  DateTime? datahora;
  String? expediente;
  ResultadoApontamento? resultado;
  List<String> marcacao = [];
  double? latitude;
  double? longitude;
  String? obs;
  String? img;
  String? imgId;
  int? status;

  Marcacao({this.iduser, this.datahora, this.expediente, this.resultado, this.obs,
     this.latitude, this.longitude, this.img, this.imgId, this.status});

  Marcacao.fromMap(Map map) {
    List _i = map["Data"].split("/");
    this.datahora = DateTime(int.parse(_i[2]), int.parse(_i[1]), int.parse(_i[0]));
    this.expediente = map["Expediente"]["Descricao"];
    this.resultado = ResultadoApontamento.fromMap(map["Resultado"]);
    this.marcacao = [
      if(map["Marcacao1"] != null)
        map["Marcacao1"],
      if(map["Marcacao2"] != null)
        map["Marcacao2"],
      if(map["Marcacao3"] != null)
        map["Marcacao3"],
      if(map["Marcacao4"] != null)
        map["Marcacao4"],
        if(map["Marcacao5"] != null)
          map["Marcacao5"],
          if(map["Marcacao6"] != null)
            map["Marcacao6"],
            if(map["Marcacao7"] != null)
              map["Marcacao7"],
              if(map["Marcacao8"] != null)
                map["Marcacao8"]
    ];
    if(( marcacao.length ) == 0 ){
      if( map["Expediente"]["Codigo"] < 0 ){
        switch( map["Expediente"]["Codigo"] ){
          case -990 :
            this.marcacao = ['Folga'];
            break;
          case -999 :
            this.marcacao = ['Dsr'];
            break;
          case -998 :
            this.marcacao = ['Afastado'];
            break;
          case -997 :
            this.marcacao = ['DescontoDSR'];
            break;
          case -996 :
            this.marcacao = ['Ferias'];
            break;
          case -994 :
            this.marcacao = ['Feriado'];
            break;
        }
      }else if(expediente != null){
        this.marcacao = [expediente!];
      }else if(map["Resultado"]["Abono"]["Minutos"] > 0){
        this.marcacao = ["Falta Abonada"];
      }else if( resultado!.faltasDias > 0 ){
        this.marcacao.add("Falta");
      }else {
        this.marcacao = ["Horas lançada no Banco de Horas"];
      }
    }else if( resultado!.faltasDias > 0 ){
      this.marcacao.add("\nFalta");
    }
  }

  Future<Map<String, dynamic>> toSql2(Map map) async {
    double? lat =  map["latitude"] == null ? null : double?.tryParse(map["latitude"]) ?? null;
    double? long =  map["longitude"] == null ? null : double?.tryParse(map["longitude"]) ?? null;
    String? end = await Gps.getEndereco(lat, long);

    Map<String, dynamic> result = {
      "UserId": int.tryParse(map["iduser"].toString()),
      "Marcacao": DateFormat('yyyy-MM-dd HH:mm').format(DateTime.tryParse(map["datahora"].toString())!),
      "Latitude": lat?.toString(),
      "Longitude": long?.toString(),
      "Endereco": end
    };
    return result;
  }

  Marcacao.fromSql(Map map) {
    this.iduser = int.tryParse(map["iduser"].toString());
    this.datahora = DateTime.tryParse(map["datahora"].toString());
    this.latitude = map["latitude"] == null ? null : double?.tryParse(map["latitude"]) ?? null;
    this.longitude = map["longitude"] == null ? null : double?.tryParse(map["longitude"]) ?? null;
  }

  Marcacao.fromReSql(Map map) {
    this.iduser = int.tryParse(map["UserId"].toString());
    this.datahora = DateTime.tryParse(map["Marcacao"].toString());
    this.latitude = map["Latitude"] == null ? null : double?.tryParse(map["Latitude"]) ?? null;
    this.longitude = map["Longitude"] == null ? null : double?.tryParse(map["Longitude"]) ?? null;
  }

  Map<String, Object?> toMap() {
    Map<String, dynamic> map = {
      "iduser": this.iduser,
      "datahora": this.datahora.toString(),
      "latitude": this.latitude.toString(),
      "longitude": this.longitude.toString(),
    };
    return map;
  }

  Map<String, dynamic> toHistMap() {
    Map<String, dynamic> map = {
      "iduser": this.iduser,
      /*
      "nome": this.nome.toString(),
      "registro": this.registro.toString(),
      "pis": this.pis.toString(),
      "cargo": this.cargo.toString(),
      */
      "datahora": this.datahora.toString(),
      "latitude": this.latitude.toString(),
      "longitude": this.longitude.toString(),
      "img": this.img,
    };
    return map;
  }

  Map<String, dynamic> toSql() {
    Map<String, dynamic> map = {
      "UserId": this.iduser,
      "Marcacao": DateFormat('yyyy-MM-dd HH:mm').format(this.datahora!),
      "Latitude": this.latitude,
      "Longitude": this.longitude,
    };
    return map;
  }

}