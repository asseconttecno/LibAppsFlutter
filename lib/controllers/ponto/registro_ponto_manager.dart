import 'package:universal_io/io.dart';
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

  Future<void> postPontoMarcar(BuildContext context, UsuarioPonto user,
      double? latitude, double? longitude, String? endereco, String? token) async {

    bool result = await _service.postPontoMarcar(user, latitude, longitude, endereco, token);
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
      List<Map<String, dynamic>> listmarcacao, {bool delete = true, String? token}) async {

    final result = await _service.postPontoMarcacoesOffline(usuario, listmarcacao, delete: delete, token: token);
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

  enviarMarcacoesHistorico(BuildContext context, UsuarioPonto? usuario, {String? token}) async {
    try{
      if (usuario != null) {
        List<Map<String, dynamic>>? marcacao = await _sqlitePonto.getHistoricoFormatado(
            UserPontoManager.susuario?.funcionario?.funcionarioId) ;

        if(marcacao != null && marcacao.isNotEmpty){
          debugPrint(marcacao.toString());
          postPontoMarcacoesOffline(context, usuario, marcacao, delete: false, token: token );
        }else{
          CustomAlert.info(
            context: context,
            mensage: 'Você não possui marcações para ser enviadas\n',
          );
        }
      } else {
        CustomAlert.info(
          context: context,
          mensage: 'Falha na autenticacao, nao foi possivel enviar as marcações\n',
        );
      }
    }catch(e){
      debugPrint("erro enviarMarcacoes offline $e");
      CustomAlert.erro(
        context: context,
        mensage: 'Não foi possivel enviar suas marcações\n$e',
      );
    }
  }

  enviarMarcacoes({String? token}) async {
    debugPrint('enviarMarcacoes off ${Config.isReenvioMarc ? '45 dias' : '1 dia'}');
    try{
      List<Map<String, dynamic>>? marcacao = await ( Config.isReenvioMarc ?
          _sqlitePonto.getHistoricoFormatado(UserPontoManager.susuario?.funcionario?.funcionarioId)
          : _sqlitePonto.getMarcacoes(UserPontoManager.susuario?.funcionario?.funcionarioId) );
      if(marcacao != null && marcacao.isNotEmpty) {
        final result =  await _service.postPontoMarcacoesOffline(
            UserPontoManager.susuario,
            marcacao,
            delete: !Config.isReenvioMarc,
            token: token
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

  enviarMarcacoesNotificacao({required String? token}) async {
    try{
      final _user = await UserPontoService().authNotificacao();

      List<Map<String, dynamic>>? marcacao = await _sqlitePonto.getHistoricoFormatado(_user?.funcionario?.funcionarioId);
      if(marcacao != null && marcacao.isNotEmpty) {
        final result =  await _service.postPontoMarcacoesOffline(
            UserPontoManager.susuario, marcacao,
            delete: false, token: token
        );
        if(result == MarcacaoOffStatus.Sucess){
          debugPrint('enviarMarcacoesNotificacao sucess');
        }else{
          debugPrint('enviarMarcacoesNotificacao erro');
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