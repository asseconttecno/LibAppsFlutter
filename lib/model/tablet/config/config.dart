
import '../../../enums/enums.dart';

class ConfigModel{
  String? email = '';
  ConfigBackup? status = ConfigBackup.Semanal;
  String? hora = '23:00';
  String? local = '';

  ConfigModel({ this.email,  this.status,  this.hora, this.local});

  ConfigModel copyWith({String? email, int? status, String? hora, String? local}) =>
      ConfigModel(
          email: email ?? this.email,
          status: status != null ? convertStatusEnum(status) : this.status,
          hora: hora ?? this.hora,
          local: local ?? this.local
      );

  ConfigModel.fromSql(Map map) {
    this.local = map["local"];
    this.hora = map["hora"];
    this.email = map["email"];
    this.status = convertStatusEnum(int.tryParse(map["status"].toString()));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "email": this.email,
      "status": convertStatusInt(this.status).toString(),
      "hora": this.hora,
      "local": this.local
    };
    return map;
  }

  int convertStatusInt(ConfigBackup? status){
    switch (status) {
      case ConfigBackup.Diario :
        return 1;
      case ConfigBackup.Semanal :
        return 2;
      case ConfigBackup.Mensal :
        return 3;
      default :
        return 2;
    }
  }

  ConfigBackup convertStatusEnum(int? status){
    switch (status) {
      case 1 :
        return ConfigBackup.Diario;
      case 2 :
        return ConfigBackup.Semanal;
      case 3 :
        return ConfigBackup.Mensal;
      default :
        return ConfigBackup.Semanal;
    }
  }
}