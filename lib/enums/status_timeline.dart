

import '../model/model.dart';

enum StatusTimeLine{
  Disponibilizado(1),
  Vizualizado(4),
  Email(2),
  Sms(3),
  Nenhum(0);

  String img(){
    switch(value){
      case 1:
        return 'assets/imagens/dispo.png';
      case 2:
        return 'assets/imagens/email.png';
      case 3:
        return 'assets/imagens/sms.png';
      case 4:
        return 'assets/imagens/visualizado.png';
      default:
        return 'assets/imagens/dispo.png';
    }
  }

  static StatusTimeLine statusTimeLine(ObrigacoesDetalhesModel obrg) {
    if(obrg.visualizadoEm != null){
      return StatusTimeLine.Vizualizado;
    }else if(obrg.smsEnviadoEm != null){
      return StatusTimeLine.Sms;
    }else if(obrg.emailEnviadoEm != null){
      return StatusTimeLine.Email;
    }else if(obrg.disponivelEm != null){
      return StatusTimeLine.Disponibilizado;
    }else {
      return StatusTimeLine.Nenhum;
    }
  }

  final int value;
  const StatusTimeLine(this.value);
}