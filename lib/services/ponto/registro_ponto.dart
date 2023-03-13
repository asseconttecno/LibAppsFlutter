import 'dart:async';
import 'package:flutter/material.dart';


import '../../controllers/controllers.dart';
import '../../enums/enums.dart';
import '../../model/model.dart';
import '../../config.dart';
import '../../utils/utils.dart';
import '../http/http.dart';
import '../sqlite_ponto.dart';


class RegistroService {
  final HttpCli _http = HttpCli();
  final SqlitePontoService _sqlitePonto = SqlitePontoService();


  Future<bool> postPontoMarcar(UsuarioPonto user, double? latitude, double? longitude) async {
    String _api = "/api/apontamento/PostPontoMarcar";

    String? endereco;
    try {
      endereco = await Conversoes.getEndereco(latitude, longitude);
    } on Exception catch (e) {
      print('erro endereco $e');
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
            await  _sqlitePonto.salvarHisMarcacao(
              Marcacao(
                  iduser: user.userId,
                  latitude: latitude, longitude: longitude,
                  datahora: DateTime.now(),
              ),
            );
            return true;
          }else{
            if(user.permitirMarcarPontoOffline ?? false){
              bool result = await _sqlitePonto.salvarMarcacao(
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
            bool result = await _sqlitePonto.salvarMarcacao(
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
          bool result = await _sqlitePonto.salvarMarcacao(
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
    String _api = "/api/apontamento/PostPontoMarcacoesOffline";

    if(usuario?.database != null){
      try{
        final MyHttpResponse response = await _http.post(
            url: Config.conf.apiAsseponto! + _api,
            body: {
              "Database": "${usuario!.database}",
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
              _sqlitePonto.deleteSalvarMarcacoes(del);
            }
            return MarcacaoOffStatus.Delete;
          }
        }
        debugPrint(response.data.toString());
        debugPrint(response.codigo.toString());
      }catch (e){
        debugPrint("Erro postPontoMarcacoesOffline ${e.toString()}");
      }
    }
    return MarcacaoOffStatus.Erro;
  }





}