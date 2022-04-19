import 'dart:async';
import 'dart:io';
import '../../common/custom_snackbar.dart';
import '../../helper/conn.dart';
import '../../helper/db.dart';
import '../../model/marcacao/marcacao.dart';
import '../../services/usuario/users_manager.dart';
import '../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

import 'gps.dart';

class RegistroManger {
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  String? bytes;
  File? image;
  int auth = 0;

  postPontoMarcar(double? latitude, double? longitude, {required Function sucess, required Function error}) async {
    String _api = "api/apontamento/PostPontoMarcar";

    if(connectionStatus.hasConnection){
      String? endereco;
      try {
        endereco = await Gps.getEndereco(latitude, longitude);
      } on Exception catch (e) {
        print('erro endereco ' + e.toString());
      }
      try{
        final http.Response response = await http.post(Uri.parse(Settings.apiUrl + Settings.apiUrl2 + _api),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              "User": {
                "UserId": "${UserManager().usuario?.userId?.toString()}",
                "Database": "${UserManager().usuario?.database?.toString()}"
              },
              "Latitude": latitude,
              "Longitude": longitude,
              "Endereco": endereco
            })
        ).timeout(Duration(seconds: 6), onTimeout: (){
          throw TimeoutException('Erro de Timeout');
        }).catchError((onError){
          if(UserManager().usuario?.permitirMarcarPontoOffline ?? false){
            salvarMarcacao(
                Marcacao(
                    iduser: UserManager().usuario?.userId,
                    latitude: latitude, longitude: longitude,
                    datahora: DateTime.now()
                ),
                sucesso: (){
                  sucess();
                },
                erro: (){
                  error(false);
                }
            );
          }else{
            error(true);
          }
        });
        if(response.statusCode == 200){
          var dadosJson = json.decode( response.body );
          if(dadosJson["IsSuccess"]){
            await salvarHisMarcacao(
              Marcacao(
                  iduser: UserManager().usuario!.userId,
                  latitude: latitude, longitude: longitude,
                  datahora: DateTime.now(),
              ),
            );
            sucess();
          }else{
            if(UserManager().usuario?.permitirMarcarPontoOffline ?? false){
              salvarMarcacao(
                  Marcacao(
                      iduser: UserManager().usuario?.userId,
                      latitude: latitude, longitude: longitude,
                      datahora: DateTime.now()
                  ),
                  sucesso: (){
                    sucess();
                  },
                  erro: (){
                    error(false);
                  }
              );
            }else{
              error(true);
            }
          }
        }else{
          if(UserManager().usuario?.permitirMarcarPontoOffline ?? false){
            salvarMarcacao(
                Marcacao(
                    iduser: UserManager().usuario?.userId,
                    latitude: latitude, longitude: longitude,
                    datahora: DateTime.now()
                ),
                sucesso: (){
                  sucess();
                },
                erro: (){
                  error(false);
                }
            );
          }else{
            error(true);
          }
        }
      }on TimeoutException{
        if(UserManager().usuario?.permitirMarcarPontoOffline ?? false){
          salvarMarcacao(
              Marcacao(
                  iduser: UserManager().usuario?.userId,
                  latitude: latitude, longitude: longitude,
                  datahora: DateTime.now()
              ),
              sucesso: (){
                sucess();
              },
              erro: (){
                error(false);
              }
          );
        }else{
          error(true);
        }
      }catch (e){
        debugPrint("Erro Try ${e.toString()}");
        if(UserManager().usuario?.permitirMarcarPontoOffline ?? false){
          salvarMarcacao(
              Marcacao(
                  iduser: UserManager().usuario?.userId,
                  latitude: latitude, longitude: longitude,
                  datahora: DateTime.now()
              ),
              sucesso: (){
                sucess();
              },
              erro: (){
                error(false);
              }
          );
        }else{
          error(true);
        }
      }
    }else if(UserManager().usuario?.permitirMarcarPontoOffline ?? false){
      salvarMarcacao(
          Marcacao(
            iduser: UserManager().usuario?.userId,
            latitude: latitude, longitude: longitude,
            datahora: DateTime.now()
          ),
          sucesso: (){
            sucess();
          },
          erro: (){
            error(false);
          }
      );
    }else{
      error(true);
    }
  }

  postPontoMarcacoesOffline(List<Map<String, dynamic>> listOff,
      {required Function sucess, required Function error, required Function deletemarcacao}) async {
    String _api = "api/apontamento/PostPontoMarcacoesOffline";

    debugPrint(listOff.toString());

    if(await connectionStatus.checkConnection() && UserManager().usuario?.database != null){
      try{
        final http.Response response = await http.post(
            Uri.parse(Settings.apiUrl + Settings.apiUrl2 + _api),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              "Database": "${UserManager().usuario?.database?.toString()}",
              "Marcacoes": listOff
            })
        ).timeout(Duration(seconds: 6), onTimeout:(){
          throw TimeoutException('Erro de Timeout');
        });
        if(response.statusCode == 200){
          Map dadosJson = json.decode( response.body );
          if(dadosJson["IsSuccess"]){
            debugPrint(dadosJson.toString());
            sucess();
          }else{
            debugPrint(dadosJson.toString());
            List list = dadosJson["Result"];
            list.sort((a, b) => b["Index"].compareTo(a["Index"]));
            list.map((e) {
              print(e["Index"] );
              listOff.removeAt( e["Index"] );
            }).toList();
            debugPrint(listOff.toString());
            deletemarcacao(listOff.map((e) => Marcacao.fromReSql(e)).toList());
          }
        }else{
          debugPrint(response.statusCode.toString());
          error();
        }
      }on TimeoutException{
        error();
      }catch (e){
        debugPrint("Erro postPontoMarcacoesOffline ${e.toString()}");
        error();
      }
    }
  }

  enviarMarcacoesHistorico(BuildContext context ) async {
    try{
      Database bancoDados = await DbSQL().db;
      List resultsql = await bancoDados.query("historico");
      List<Map<String, dynamic>> marcacao = resultsql.map( (e) => Marcacao.fromSql(e).toSql()  ).toList() ;
      debugPrint(marcacao.toString());
      if(marcacao.length > 0){
        debugPrint(marcacao.toString());
        await postPontoMarcacoesOffline(
            marcacao,
            sucess: () async {
              debugPrint('sucess');
              SuccessAlertBox(
                  context: context,
                  title: 'Sucesso',
                  messageText: 'Marcações enviadas para Asseponto!\n',
                  buttonText: 'OK'
              );
            }, error: (){
          debugPrint('error');
          InfoAlertBox(
              context: context,
              title: 'Falha',
              infoMessage: 'Não foi possivel enviar suas marcações\n',
              buttonText: 'OK'
          );
        },
            deletemarcacao: (List<Marcacao> e) async {
              SuccessAlertBox(
                  context: context,
                  title: 'Sucesso',
                  messageText: 'Marcações enviadas para Asseponto!\n',
                  buttonText: 'OK'
              );
            }
        );
      }else{
        InfoAlertBox(
            context: context,
            title: 'Ops',
            infoMessage: 'Não foi possivel enviar suas marcações\n',
            buttonText: 'OK'
        );
      }
    }catch(e){
      debugPrint("erro enviarMarcacoes offline $e");
      InfoAlertBox(
          context: context,
          title: 'Erro',
          infoMessage: 'Não foi possivel enviar suas marcações\n',
          buttonText: 'OK'
      );
    }
  }

  enviarMarcacoes( ) async {
    try{
      Database bancoDados = await DbSQL().db;
      List _sql = await bancoDados.query("marcacao");
      if(_sql.length > 0) {
        List<Map<String, dynamic>> marcacao = await Future.wait(
            _sql.map((e) => Marcacao().toSql2(e)).toList());
        //List<Map<String, dynamic>> marcacao = resultsql.map( (e) => Marcacao.fromSql(e).toSql()  ).toList() ;
        debugPrint(marcacao.toString());
        if(marcacao != null && marcacao.length > 0){
          debugPrint(marcacao.toString());
          await postPontoMarcacoesOffline(
              marcacao,
              sucess: () async {
                debugPrint('sucess');
                Settings.scaffoldKey.currentState != null ?
                customSnackbar('Marcações sincronizadas com sucesso', Colors.blue[900]!, Settings.scaffoldKey)
                    : null;
                var _result = await bancoDados.delete("marcacao");
                debugPrint( _result.toString() );
              }, error: (){
            debugPrint('error');
          },
              deletemarcacao: (List<Marcacao> e) async {
                await bancoDados.delete("marcacao");
                await e.map((e) async {
                  await salvarMarcacao(e,
                      sucesso: (){},
                      erro: (){
                        salvarMarcacao(e,
                            sucesso: (){},
                            erro: (){}
                        );
                      }
                  );
                });
              }
          );
        }
      }


    }catch(e){
      debugPrint("erro enviarMarcacoes offline ${e.toString()}");
    }
  }

  salvarHisMarcacao(Marcacao dados) async {
    try{
      Database bancoDados = await DbSQL().db;
      await bancoDados.insert("historico", dados.toHistMap());
    }catch(e){
      debugPrint("erro salvar marca sql $e");
    }
  }

  salvarMarcacao(Marcacao dados, {bool hist = true, required Function sucesso, required Function erro}) async {
    try{
      Database bancoDados = await DbSQL().db;
      int result = await bancoDados.insert("marcacao", dados.toMap());
      try{
        if(hist) await bancoDados.insert("historico", dados.toHistMap());
      }catch(e){
        debugPrint("erro salvar marca sql ${e.toString()}");
      }
      if(result != null){
        String sql = "SELECT * FROM marcacao";
        List marcacao = await bancoDados.rawQuery(sql);
        debugPrint(marcacao.toString());
        sucesso();
      }
    }catch(e){
      debugPrint("erro salvar marca sql ${e.toString()}");
      erro();
    }
  }

  deleteHistorico() async {
    try{
      Database bancoDados = await DbSQL().db;
      String sql = "SELECT * FROM historico";
      List _select = await bancoDados.rawQuery(sql);
      if(_select.isNotEmpty){
        List<Marcacao> _listMarc = _select.map((e) => Marcacao.fromSql(e)).toList();
        await bancoDados.delete('historico');
        _listMarc.map((e) async {
          if((e.datahora?.difference(DateTime.now()).inDays ?? 100) < 40){
            await salvarHisMarcacao(e);
          }
        }).toList();
      }
    }catch(e){
      debugPrint("erro deleteHistorico sql $e");
    }
  }
}