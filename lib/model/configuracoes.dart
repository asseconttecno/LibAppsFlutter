
import '../enums/enums.dart';

class ConfiguracoesModel {
  final String? apiAsseweb;
  final String? apiHolerite;
  final String? apiHoleriteEmail;
  final String? apiAsseponto;
  final String? apiAssepontoNova;
  final String? apiEspelho;
  final String? apiBoletos;
  final String? apiRelatorioFechamento;
  final String? androidAppId ;
  final String? iosAppId;
  final String? iosAppIdNum ;

  final VersaoApp? nomeApp;

  const ConfiguracoesModel(
      {this.apiAsseweb,
      this.apiHolerite,
      this.apiHoleriteEmail,
      this.apiAsseponto,
      this.apiAssepontoNova,
      this.apiRelatorioFechamento,
      this.apiBoletos,
      this.apiEspelho,
      this.androidAppId,
      this.iosAppId,
      this.iosAppIdNum,
      this.nomeApp});
}