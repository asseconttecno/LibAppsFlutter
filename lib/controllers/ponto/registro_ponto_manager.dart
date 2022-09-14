import 'dart:io';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../enums/enums.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../../config.dart';
import '../controllers.dart';


class RegistroManger {
  RegistroService _service = RegistroService();
  SqlitePontoService _sqlitePonto = SqlitePontoService();


  String? bytes;
  File? image;
  int auth = 0;

  postPontoMarcar(BuildContext context, UsuarioPonto user, double? latitude, double? longitude) async {
    bool result = await _service.postPontoMarcar(user, latitude, longitude);
    if(result){
      CustomAlert.sucess(
        context: context,
        mensage: 'Marcação registrada!',
      );
    }else{
      if(user.permitirMarcarPontoOffline ?? false){
        CustomAlert.erro(
          context: context,
          mensage: 'Marcação não registrada, tente novamente!',
        );
      }else{
        CustomAlert.info(
          context: context,
          mensage: 'Você não tem permissão para marca o ponto sem internet!',
        );
      }
    }
  }

  postPontoMarcacoesOffline(BuildContext context, UsuarioPonto usuario,
      List<Map<String, dynamic>> listmarcacao, {bool delete = true}) async {

    final result = await _service.postPontoMarcacoesOffline(usuario, listmarcacao, delete: delete);
    if(result == MarcacaoOffStatus.Erro){
      CustomAlert.erro(
        context: context,
        mensage: 'Não foi possivel enviar suas marcações\n',
      );
    } else {
      CustomAlert.sucess(
        context: context,
        mensage: 'Marcações enviadas para Asseponto!\n',
      );
    }
  }

  enviarMarcacoesHistorico(BuildContext context, UsuarioPonto? usuario) async {
    try{
      if (usuario != null) {
        List<Map<String, dynamic>>? marcacao = await _sqlitePonto.getHistoricoFormatado() ;

        if(marcacao != null && marcacao.isNotEmpty){
          debugPrint(marcacao.toString());
          postPontoMarcacoesOffline(context, usuario, marcacao, delete: false);
        }else{
          CustomAlert.info(
            context: context,
            mensage: 'Não foi possivel enviar suas marcações\n',
          );
        }
      } else {
        CustomAlert.info(
          context: context,
          mensage: 'Não foi possivel enviar suas marcações\n',
        );
      }
    }catch(e){
      debugPrint("erro enviarMarcacoes offline $e");
      CustomAlert.erro(
        context: context,
        mensage: 'Não foi possivel enviar suas marcações\n',
      );
    }
  }

  enviarMarcacoes() async {
    print('enviarMarcacoes off');
    try{
      List<Map<String, dynamic>> marcacao = await _sqlitePonto.getMarcacoes();
      if(marcacao.isNotEmpty) {
        final result =  await _service.postPontoMarcacoesOffline(
            UserPontoManager().usuario,
            marcacao,
            delete: true
        );
        if(result == MarcacaoOffStatus.Sucess){
          debugPrint('sucess');
          if(Config.scaffoldKey.currentState != null) {
            CustomSnackbar.scaffoldKey(Config.scaffoldKey, 'Marcações sincronizadas com sucesso', Colors.blue[900]!);
          }
          int _result = await _sqlitePonto.deleteMarcacoes();
          debugPrint( _result.toString() );
        }
      }
    }catch(e){
      debugPrint("erro enviarMarcacoes offline ${e.toString()}");
    }
  }

  deleteHistorico() async {
    _sqlitePonto.deleteHistorico();
  }
}