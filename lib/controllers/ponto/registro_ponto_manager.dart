import 'dart:io';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../enums/enums.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../../config.dart';
import '../controllers.dart';


class RegistroManger {
  final RegistroService _service = RegistroService();
  final SqlitePontoService _sqlitePonto = SqlitePontoService();


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
      if(user.funcionario?.permitirMarcarPontoOffline ?? false){
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
        List<Map<String, dynamic>>? marcacao = await _sqlitePonto.getHistoricoFormatado(UserPontoManager.susuario?.funcionario?.funcionarioId) ;

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
    debugPrint('enviarMarcacoes off ' + (Config.isReenvioMarc ? '45 dias' : '1 dia'));
    try{
      List<Map<String, dynamic>>? marcacao = await ( Config.isReenvioMarc ?
          _sqlitePonto.getHistoricoFormatado(UserPontoManager.susuario?.funcionario?.funcionarioId)
          : _sqlitePonto.getMarcacoes(UserPontoManager.susuario?.funcionario?.funcionarioId) );
      if(marcacao != null && marcacao.isNotEmpty) {
        final result =  await _service.postPontoMarcacoesOffline(
            UserPontoManager.susuario,
            marcacao,
            delete: !Config.isReenvioMarc
        );
        if(result == MarcacaoOffStatus.Sucess){
          debugPrint('sucess');
          if(Config.scaffoldKey.currentState != null) {
            CustomSnackbar.scaffoldKey(Config.scaffoldKey, 'Marcações sincronizadas com sucesso', Colors.blue[900]!);
          }
          if(!Config.isReenvioMarc){
            int _result = await _sqlitePonto.deleteMarcacoes(UserPontoManager.susuario?.funcionario?.funcionarioId);
            debugPrint( _result.toString() );
          }
        }
      }
    }catch(e){
      debugPrint("erro enviarMarcacoes offline ${e.toString()}");
    }
  }

  deleteHistorico() async {
    if(!Config.isReenvioMarc){
      _sqlitePonto.deleteHistorico(UserPontoManager.susuario?.funcionario?.funcionarioId);
    }
  }
}