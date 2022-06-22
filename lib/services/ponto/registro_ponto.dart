import 'dart:async';
import 'package:flutter/material.dart';


import '../../controllers/controllers.dart';
import '../../enums/enums.dart';
import '../../model/model.dart';
import '../../helper/db.dart';
import '../../config.dart';
import '../http/http.dart';


class RegistroService {
  final HttpCli _http = HttpCli();

  Future<bool> postPontoMarcar(UsuarioPonto user, double? latitude, double? longitude) async {
    String _api = "api/apontamento/PostPontoMarcar";

    String? endereco;
    try {
      endereco = await Gps.getEndereco(latitude, longitude);
    } on Exception catch (e) {
      print('erro endereco ' + e.toString());
    }

    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAsseponto! + _api,
        body: {
          "User": {
            "UserId": user.userId?.toString(),
            "Database": user.database?.toString()
          },
          "Latitude": latitude,
          "Longitude": longitude,
          "Endereco": endereco
        }
    );

    try{
        if(response.isSucess){
          Map dadosJson = response.data;
          if(dadosJson.containsKey("IsSuccess") && dadosJson["IsSuccess"]){
            await  salvarHisMarcacao(
              Marcacao(
                  iduser: user.userId,
                  latitude: latitude, longitude: longitude,
                  datahora: DateTime.now(),
              ),
            );
            return true;
          }else{
            if(user.permitirMarcarPontoOffline ?? false){
              bool result = await salvarMarcacao(
                  Marcacao(
                      iduser: user.userId,
                      latitude: latitude, longitude: longitude,
                      datahora: DateTime.now()
                  ),
              );
              return result;
            }
          }
        }else{
          if(user.permitirMarcarPontoOffline ?? false){
            bool result = await salvarMarcacao(
              Marcacao(
                  iduser: user.userId,
                  latitude: latitude, longitude: longitude,
                  datahora: DateTime.now()
              ),
            );
            return result;
          }
        }
      } catch (e){
        debugPrint("Erro Try ${e.toString()}");
        if(user.permitirMarcarPontoOffline ?? false){
          bool result = await salvarMarcacao(
            Marcacao(
                iduser: user.userId,
                latitude: latitude, longitude: longitude,
                datahora: DateTime.now()
            ),
          );
          return result;
        }
      }
      return false;
  }

  Future<MarcacaoOffStatus> postPontoMarcacoesOffline(UsuarioPonto? usuario,
      List<Map<String, dynamic>> listOff, {bool delete = false}) async {
    String _api = "api/apontamento/PostPontoMarcacoesOffline";

    if(usuario?.database != null){
      try{
        final MyHttpResponse response = await _http.post(
            url: Config.conf.apiAsseponto! + _api,
            body: {
              "Database": "${usuario?.database?.toString()}",
              "Marcacoes": listOff
            }
        );

        if(response.isSucess){
          Map dadosJson = response.data;
          if(dadosJson.containsKey("IsSuccess") && dadosJson["IsSuccess"]){
            return MarcacaoOffStatus.Sucess;
          }else{
            debugPrint(dadosJson.toString());
            List list = dadosJson["Result"];
            list.sort((a, b) => b["Index"].compareTo(a["Index"]));
            list.map((e) {listOff.removeAt( e["Index"] ); }).toList();

            final del = listOff.map((e) => Marcacao.fromReSql(e)).toList();
            if(delete){
              var bancoDados = await DbSQL().db;
              await bancoDados.delete("marcacao");
              await del.map((e) async {
                await salvarMarcacao(e);
              });
            }
            return MarcacaoOffStatus.Delete;
          }
        }
      }catch (e){
        debugPrint("Erro postPontoMarcacoesOffline ${e.toString()}");
      }
    }
    return MarcacaoOffStatus.Erro;
  }




  Future<bool> salvarMarcacao(Marcacao dados, {bool hist = true}) async {
    try{
      var bancoDados = await DbSQL().db;
      int result = await bancoDados.insert("marcacao", dados.toMap());

      try {
        if(hist) await bancoDados.insert("historico", dados.toHistMap());
      } on Exception catch (e) {
        debugPrint("erro salvar marca sql ${e.toString()}");
      }

      return result > 0;
    }catch(e){
      debugPrint("erro salvar marca sql ${e.toString()}");
      return false;
    }
  }

  Future<bool> salvarHisMarcacao(Marcacao dados) async {
    try{
      var bancoDados = await DbSQL().db;
      int result = await bancoDados.insert("historico", dados.toHistMap());
      return result > 0;
    }catch(e){
      debugPrint("erro salvar marca sql $e");
      return false;
    }
  }


}