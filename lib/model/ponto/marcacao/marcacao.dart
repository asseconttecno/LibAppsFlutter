import 'package:intl/intl.dart';

import '../../../controllers/controllers.dart';
import '../../../utils/utils.dart';
import 'resultado_apontamento.dart';


class Marcacao {
  int? iduser;
  DateTime? datahora;
  String? expediente;
  ResultadoApontamento? resultado;
  List<String> marcacao = [];
  double? latitude;
  double? longitude;
  String? endereco;
  String? obs;
  String? img;
  String? imgId;
  int? status;

  Marcacao({this.iduser, this.datahora, this.expediente, this.resultado, this.obs,
     this.latitude, this.longitude, this.img, this.imgId, this.status});

  Marcacao.fromMap(Map map) {
    List _i = map["Data"].split("/");
    datahora = DateTime(int.parse(_i[2]), int.parse(_i[1]), int.parse(_i[0]));
    expediente = map["Expediente"]["Descricao"];
    resultado = ResultadoApontamento.fromMap(map["Resultado"]);
    marcacao = [
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
            marcacao = ['Folga'];
            break;
          case -999 :
            marcacao = ['Dsr'];
            break;
          case -998 :
            marcacao = ['Afastado'];
            break;
          case -997 :
            marcacao = ['DescontoDSR'];
            break;
          case -996 :
            marcacao = ['Ferias'];
            break;
          case -994 :
            marcacao = ['Feriado'];
            break;
        }
      }else if(expediente != null){
        marcacao = [expediente!];
      }else if(map["Resultado"]["Abono"]["Minutos"] > 0){
        marcacao = ["Falta Abonada"];
      }else if( resultado!.faltasDias > 0 ){
        marcacao.add("Falta");
      }else {
        marcacao = ["Horas lançada no Banco de Horas"];
      }
    }else if( resultado!.faltasDias > 0 ){
      marcacao.add("\nFalta");
    }
  }

  Map<String, dynamic> toSql2(Map map) {
    double? lat =  map["latitude"] == null ? null : double.tryParse(map["latitude"]);
    double? long =  map["longitude"] == null ? null : double.tryParse(map["longitude"]);
    String? end = map["Endereco"];

    Map<String, dynamic> result = {
      "DataHora": DateFormat('yyyy-MM-dd HH:mm').format(DateTime.tryParse(map["datahora"].toString())!),
      "Latitude": lat?.toString(),
      "Longitude": long?.toString(),
      "Endereco": end
    };
    return result;
  }

  Marcacao.fromSql(Map map) {
    iduser = int.tryParse(map["iduser"].toString());
    datahora = DateTime.tryParse(map["datahora"].toString());
    latitude = map["latitude"] == null ? null : double.tryParse(map["latitude"]);
    longitude = map["longitude"] == null ? null : double.tryParse(map["longitude"]);
    endereco = map["Endereco"] == null ? null : map["Endereco"].toString();
  }

  Marcacao.fromReSql(Map map) {
    iduser = int.tryParse(map["UserId"].toString());
    datahora = DateTime.tryParse(map["Marcacao"].toString());
    latitude = map["Latitude"] == null ? null : double.tryParse(map["Latitude"]);
    longitude = map["Longitude"] == null ? null : double.tryParse(map["Longitude"]);
    endereco = map["Endereco"] == null ? null : map["Endereco"].toString();
  }

  Map<String, Object?> toMap() {
    Map<String, dynamic> map = {
      "iduser": iduser,
      "datahora": datahora.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "Endereco": endereco,
    };
    return map;
  }

  Map<String, dynamic> toHistMap() {
    Map<String, dynamic> map = {
      "iduser": iduser,
      /*
      "nome": this.nome.toString(),
      "registro": this.registro.toString(),
      "pis": this.pis.toString(),
      "cargo": this.cargo.toString(),
      */
      "datahora": datahora.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "Endereco": endereco,
      "img": img,
    };
    return map;
  }

  Map<String, dynamic> toSql() {
    Map<String, dynamic> map = {
      "DataHora": DateFormat('yyyy-MM-dd HH:mm').format(datahora!),
      "Latitude": latitude,
      "Longitude": longitude,
      "Endereco": endereco,
    };
    return map;
  }

}