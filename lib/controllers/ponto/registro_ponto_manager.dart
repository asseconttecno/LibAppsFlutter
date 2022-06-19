import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../enums/enums.dart';
import '../../helper/db.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../../settintgs.dart';
import '../controllers.dart';


class RegistroManger {
  RegistroService _service = RegistroService();

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
        var bancoDados = await DbSQL().db;
        List resultsql = await bancoDados.query("historico");
        List<Map<String, dynamic>> marcacao = resultsql.map( (e) => Marcacao.fromSql(e).toSql()  ).toList() ;

        if(marcacao.isNotEmpty){
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
    try{
      var bancoDados = await DbSQL().db;
      List _sql = await bancoDados.query("marcacao");
      if(_sql.isNotEmpty) {
        List<Map<String, dynamic>> marcacao = await Future.wait(
            _sql.map((e) => Marcacao().toSql2(e)).toList());
        //List<Map<String, dynamic>> marcacao = resultsql.map( (e) => Marcacao.fromSql(e).toSql()  ).toList() ;

        if(marcacao.isNotEmpty){
          final result =  await _service.postPontoMarcacoesOffline(
              UserPontoManager().usuario,
              marcacao,
              delete: true
          );
          if(result == MarcacaoOffStatus.Sucess){
            debugPrint('sucess');
            if(Settings.scaffoldKey.currentState != null)
              CustomSnackbar.scaffoldKey(Settings.scaffoldKey, 'Marcações sincronizadas com sucesso', Colors.blue[900]!);
            var _result = await bancoDados.delete("marcacao");
            debugPrint( _result.toString() );
          }
        }
      }
    }catch(e){
      debugPrint("erro enviarMarcacoes offline ${e.toString()}");
    }
  }

  deleteHistorico() async {
    try{
      var bancoDados = await DbSQL().db;
      String sql = "SELECT * FROM historico";
      List _select = await bancoDados.rawQuery(sql);
      if(_select.isNotEmpty){
        List<Marcacao> _listMarc = _select.map((e) => Marcacao.fromSql(e)).toList();
        await bancoDados.delete('historico');
        _listMarc.map((e) async {
          if((e.datahora?.difference(DateTime.now()).inDays ?? 100) < 40){
            await _service.salvarHisMarcacao(e);
          }
        }).toList();
      }
    }catch(e){
      debugPrint("erro deleteHistorico sql $e");
    }
  }
}