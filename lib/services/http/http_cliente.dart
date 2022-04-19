import 'dart:async';
import 'dart:convert';
import 'package:assecontservices/services/http/http_response.dart';
import 'package:flutter/material.dart';

import "package:http/http.dart" as http;

import 'http_error.dart';
import '../../helper/conn.dart';


class HttpCli {
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  Future<HttpResponse> get(
      {required String url, Map<String, String>? headers, bool decoder = true, bool bits = false,}) async {

      if(!connectionStatus.hasConnection){
        return HttpResponse(
          isSucess: false,
          httpError: HttpError.conection,
          data: 'Falha de conexão com internet'
        );
      }
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers ?? <String, String>{
          'Content-Type': 'application/json',
        }
      ).timeout(const Duration(seconds: 10), onTimeout : () {
        debugPrint('get timeout');
        throw HttpError.timeout;
      }).catchError((error, stackTrace) {
        debugPrint('onError ' + error.toString());

        return HttpResponse(
            isSucess: false,
            httpError: error == HttpError.timeout ? HttpError.timeout : HttpError.unexpected,
            data: error == HttpError.timeout ?
            'Tempo limite de conexão excedido' :  'Erro inesperado, tente novamente mais tarde'
        );
      });

      try{
        if(response.statusCode == 200){
          var result = bits ? response.bodyBytes : decoder ? json.decode(response.body) : response.body;
          return HttpResponse(
              isSucess: true,
              codigo: 200,
              data: result
          );
        } else {
          throw HttpError.statusCode;
        }

      } catch(e){
        debugPrint('catch ' + e.toString());
        bool r = e == HttpError.statusCode;
        return HttpResponse(
            isSucess: false,
            httpError: r ? HttpError.statusCode : HttpError.unexpected,
            codigo: response.statusCode,
            data: r ? response.body :  'Erro inesperado, tente novamente mais tarde'
        );
      }
  }


  Future<HttpResponse> post({required String url, Map<String, String>? headers,
      Map<String, dynamic>? body, bool decoder = true}) async {

    if(!connectionStatus.hasConnection){
      return HttpResponse(
          isSucess: false,
          httpError: HttpError.conection,
          data: 'Falha de conexão com internet'
      );
    }

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers ?? <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body)
    ).timeout(const Duration(seconds: 10), onTimeout : () {
      debugPrint('post timeout');
      throw HttpError.timeout;
    }).catchError((error, stackTrace) {
      debugPrint('onError ' + error.toString());

      return HttpResponse(
          isSucess: false,
          httpError: error == HttpError.timeout ? HttpError.timeout : HttpError.unexpected,
          data: error == HttpError.timeout ?
          'Tempo limite de conexão excedido' :  'Erro inesperado, tente novamente mais tarde'
      );
    });

    try{
      if(response.statusCode == 200){
        final result =  decoder ? json.decode(response.body) : response.body;
        return HttpResponse(
            isSucess: true,
            codigo: 200,
            data: result
        );
      } else {
        throw HttpError.statusCode;
      }

    } catch(e){
      debugPrint('catch ' + e.toString());
      bool r = e == HttpError.statusCode;
      return HttpResponse(
          isSucess: false,
          httpError: r ? HttpError.statusCode : HttpError.unexpected,
          codigo: response.statusCode,
          data: r ? response.body :  'Erro inesperado, tente novamente mais tarde'
      );
    }
  }

  Future<HttpResponse> put({required String url, Map<String, String>? headers,
        Map<String, dynamic>? body, bool decoder = true}) async {
    if(!connectionStatus.hasConnection){
      return HttpResponse(
          isSucess: false,
          httpError: HttpError.conection,
          data: 'Falha de conexão com internet'
      );
    }

    final http.Response response = await http.put(
        Uri.parse(url),
        headers: headers ?? <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body)
    ).timeout(const Duration(seconds: 10), onTimeout : () {
      debugPrint('get timeout');
      throw HttpError.timeout;
    }).catchError((error, stackTrace) {
      debugPrint('onError ' + error.toString());

      return HttpResponse(
          isSucess: false,
          httpError: error == HttpError.timeout ? HttpError.timeout : HttpError.unexpected,
          data: error == HttpError.timeout ?
          'Tempo limite de conexão excedido' :  'Erro inesperado, tente novamente mais tarde'
      );
    });

    try{
      if(response.statusCode == 200){
        final result = decoder ? json.decode(response.body) : response.body;
        return HttpResponse(
            isSucess: true,
            codigo: 200,
            data: result
        );
      } else {
        throw HttpError.statusCode;
      }

    } catch(e){
      debugPrint('catch ' + e.toString());
      bool r = e == HttpError.statusCode;
      return HttpResponse(
          isSucess: false,
          httpError: r ? HttpError.statusCode : HttpError.unexpected,
          codigo: response.statusCode,
          data: r ? response.body :  'Erro inesperado, tente novamente mais tarde'
      );
    }
  }
}