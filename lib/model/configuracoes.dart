
import '../enums/enums.dart';

class ConfiguracoesModel {
  String? apiAsseweb;
  String? apiHolerite;
  String? apiHoleriteEmail;
  String? apiAsseponto;
  String? apiEspelho;
  String? androidAppId ;
  String? iosAppId;
  String? iosAppIdNum ;

  VersaoApp? nomeApp;

  ConfiguracoesModel(
      {this.apiAsseweb,
      this.apiHolerite,
      this.apiHoleriteEmail,
      this.apiAsseponto,
      this.apiEspelho,
      this.androidAppId,
      this.iosAppId,
      this.iosAppIdNum,
      this.nomeApp});
}