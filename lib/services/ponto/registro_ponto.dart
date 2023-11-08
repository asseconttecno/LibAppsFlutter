import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
    String _api = "/api/marcacao/verificarMarcacoesFuncionario";

    String? endereco;
    if(latitude != null && longitude != null){
      try {
        endereco = await Conversoes.getEndereco(latitude, longitude);
      } catch (e) {
        debugPrint('erro endereco $e');
      }
    }

    DateTime now = DateTime.now();
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAssepontoNova! + _api, decoder: false,
        body: {
          "UserId": user.funcionario?.funcionarioId.toString(),
          "Database": user.databaseId.toString(),
          "Origem": kIsWeb ? 4 : 3,
          "ListaMarcacoes": [
            {
              "Latitude": latitude,
              "Longitude": longitude,
              "Endereco": endereco
            }
          ]
        }
    );

    print(response.isSucess);
    print(response.data);
    try{
        if(response.isSucess){
          /*Map dadosJson = response.data;
          if(dadosJson.containsKey("IsSuccess") && dadosJson["IsSuccess"]){
            await  _sqlitePonto.salvarHisMarcacao(
              Marcacao(
                  iduser: user.funcionario?.funcionarioId,
                  latitude: latitude, longitude: longitude,
                  datahora: now,
                  endereco: endereco
              ),
            );
            return true;
          }else{
            if(user.funcionario?.permitirMarcarPontoOffline ?? false){
              bool result = await _sqlitePonto.salvarMarcacao(
                  Marcacao(
                      iduser: user.funcionario?.funcionarioId,
                      latitude: latitude, longitude: longitude,
                      datahora: now,
                      endereco: endereco
                  ),
              );
              return result;
            }
          }*/

          await  _sqlitePonto.salvarHisMarcacao(
            Marcacao(
                iduser: user.funcionario?.funcionarioId,
                latitude: latitude, longitude: longitude,
                datahora: now,
                endereco: endereco
            ),
          );
          return true;
        }else{
          if(user.funcionario?.permitirMarcarPontoOffline ?? false){
            bool result = await _sqlitePonto.salvarMarcacao(
              Marcacao(
                  iduser: user.funcionario?.funcionarioId,
                  latitude: latitude, longitude: longitude,
                  datahora: now,
                  endereco: endereco
              ),
            );
            return result;
          }
        }
      } catch (e){
        debugPrint("Erro Try ${e.toString()}");
        if(user.funcionario?.permitirMarcarPontoOffline ?? false){
          bool result = await _sqlitePonto.salvarMarcacao(
            Marcacao(
                iduser: user.funcionario?.funcionarioId,
                latitude: latitude, longitude: longitude,
                datahora: now,
                endereco: endereco
            ),
          );
          return result;
        }
      }
      return false;
  }

  Future<MarcacaoOffStatus> postPontoMarcacoesOffline(UsuarioPonto? usuario,
      List<Map<String, dynamic>> listOff, {bool delete = false}) async {
    String _api = "/api/marcacao/verificarMarcacoesFuncionario";

    if(usuario?.databaseId != null){
      try{

        final body = {
          "Database": "${usuario!.databaseId}",
          "UserId": usuario.funcionario?.funcionarioId.toString(),
          "Origem": kIsWeb ? 4 : 7,
          "ListaMarcacoes": listOff
        };
        print(jsonEncode(body));

        final MyHttpResponse response = await _http.post(
            url: Config.conf.apiAssepontoNova! + _api,
            body: body, decoder: false
        );

        if(response.isSucess){

          return MarcacaoOffStatus.Sucess;
          /*Map dadosJson = response.data;
          if(dadosJson.containsKey("IsSuccess") && dadosJson["IsSuccess"]){
            return MarcacaoOffStatus.Sucess;
          }else if(dadosJson.containsKey("Result")){
            debugPrint(dadosJson.toString());
            List list = dadosJson["Result"];
            list.sort((a, b) => b["Index"].compareTo(a["Index"]));
            list.map((e) {listOff.removeAt( e["Index"] ); }).toList();

            final del = listOff.map((e) => Marcacao.fromReSql(e)).toList();
            if(delete){
              _sqlitePonto.deleteSalvarMarcacoes(del);
            }
            return MarcacaoOffStatus.Delete;
          }*/
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