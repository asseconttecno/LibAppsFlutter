import 'dart:async';
import 'dart:convert';
import 'package:assecontservices/services/http/http_response.dart';
import 'package:flutter/material.dart';

import "package:http/http.dart" as http;

import 'http_error.dart';
import '../../helper/conn.dart';


class HttpCli {
  final ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  Future<MyHttpResponse> get(
      {required String url, Map<String, String>? headers, bool decoder = true, bool bits = false, bool isCon = true,}) async {

      if(isCon && !connectionStatus.hasConnection){
        return MyHttpResponse(
          isSucess: false,
          httpError: HttpError.conection,
          data: 'Falha de conexão com internet'
        );
      }
      try {
        final http.Response response = await http.get(
          Uri.parse(url),
          headers: headers ?? <String, String>{
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin':'*'
          }
        ).timeout(const Duration(seconds: 15), onTimeout : () {
          debugPrint('get timeout');
          throw HttpError.timeout;
        });

        try{
          if(response.statusCode >= 200 && response.statusCode < 300){
            var result = bits ? response.bodyBytes : decoder ? json.decode(response.body) : response.body;
            return MyHttpResponse(
              isSucess: true,
              codigo: 200,
              data: result,
              extencao: !response.headers.containsKey('content-disposition') ? null :
              response.headers['content-disposition']!.contains('html') ? 'html' :
              response.headers['content-disposition']!.contains('pdf') ? 'pdf' :
              response.headers['content-disposition']!.contains('txt') ? 'txt' :
              response.headers['content-disposition']!.contains('xlsx') ? 'xlsx' :
              response.headers['content-disposition']!.contains('xls') ? 'xls' :
              response.headers['content-disposition']!.contains('docx') ? 'docx' :
              response.headers['content-disposition']!.contains('doc') ? 'doc' :
              response.headers['content-disposition']!.contains('json') ? 'json' : null
            );
          } else {

            throw HttpError.statusCode;
          }

        } catch(e){
          debugPrint('catch $e');
          debugPrint(response.statusCode.toString());
          debugPrint(response.body);
          bool r = e == HttpError.statusCode;
          return MyHttpResponse(
              isSucess: false,
              httpError: r ? HttpError.statusCode : HttpError.unexpected,
              codigo: response.statusCode,
              data: r ? response.body :  'Erro inesperado, tente novamente mais tarde'
          );
        }
      } catch (error) {
        debugPrint('onError $error');
        return MyHttpResponse(
            isSucess: false,
            httpError: error == HttpError.timeout ? HttpError.timeout : HttpError.unexpected,
            data: error == HttpError.timeout ?
            'Tempo limite de conexão excedido' :  'Erro inesperado, tente novamente mais tarde'
        );
      }
  }


  Future<MyHttpResponse> post({required String url, Map<String, String>? headers,
      Map<String, dynamic>? body, bool decoder = true, bool isbyte = false, int timeout = 55}) async {

    if(!connectionStatus.hasConnection){
      return MyHttpResponse(
          isSucess: false,
          httpError: HttpError.conection,
          data: 'Falha de conexão com internet'
      );
    }

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers ?? <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'charset': 'UTF-8',
        },
        body: jsonEncode(body)
      ).timeout(Duration(seconds: timeout), onTimeout : () {
        debugPrint('post timeout');
        throw HttpError.timeout;
      });

      try{
        if(response.statusCode >= 200 && response.statusCode < 300){
          final result =  isbyte ? response.bodyBytes : decoder ? json.decode(response.body) : response.body;
          return MyHttpResponse(
              isSucess: true,
              codigo: 200,
              data: result,
              extencao: !response.headers.containsKey('content-disposition') ? null :
              response.headers['content-disposition']!.contains('html') ? 'html' :
              response.headers['content-disposition']!.contains('pdf') ? 'pdf' :
              response.headers['content-disposition']!.contains('txt') ? 'txt' :
              response.headers['content-disposition']!.contains('xlsx') ? 'xlsx' :
              response.headers['content-disposition']!.contains('xls') ? 'xls' :
              response.headers['content-disposition']!.contains('docx') ? 'docx' :
              response.headers['content-disposition']!.contains('doc') ? 'doc' :
              response.headers['content-disposition']!.contains('json') ? 'json' : null
          );
        } else {
          debugPrint(response.body);
          throw HttpError.statusCode;
        }

      } catch(e){
        debugPrint('post catch $e');
        bool r = e == HttpError.statusCode;
        return MyHttpResponse(
            isSucess: false,
            httpError: r ? HttpError.statusCode : HttpError.unexpected,
            codigo: response.statusCode,
            data: r ? response.body :  'Erro inesperado, tente novamente mais tarde'
        );
      }
    }  catch (error) {
      debugPrint('post onError $error');
      return MyHttpResponse(
          isSucess: false,
          httpError: error == HttpError.timeout ? HttpError.timeout : HttpError.unexpected,
          data: error == HttpError.timeout ?
          'Tempo limite de conexão excedido' :  'Erro inesperado, tente novamente mais tarde'
      );
    }
  }

  Future<MyHttpResponse> put({required String url, Map<String, String>? headers,
        Map<String, dynamic>? body, bool decoder = true}) async {
    if(!connectionStatus.hasConnection){
      return MyHttpResponse(
          isSucess: false,
          httpError: HttpError.conection,
          data: 'Falha de conexão com internet'
      );
    }

    try {
      final http.Response response = await http.put(
          Uri.parse(url),
          headers: headers ?? <String, String>{
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin':'*'
          },
          body: jsonEncode(body)
      ).timeout(const Duration(seconds: 15), onTimeout : () {
        debugPrint('get timeout');
        throw HttpError.timeout;
      });

      try{
        if(response.statusCode >= 200 && response.statusCode < 300){
          final result = decoder ? json.decode(response.body) : response.body;
          return MyHttpResponse(
              isSucess: true,
              codigo: 200,
              data: result,
              extencao: !response.headers.containsKey('content-disposition') ? null :
                response.headers['content-disposition']!.contains('html') ? 'html' :
                response.headers['content-disposition']!.contains('pdf') ? 'pdf' :
                response.headers['content-disposition']!.contains('txt') ? 'txt' :
                response.headers['content-disposition']!.contains('xlsx') ? 'xlsx' :
                response.headers['content-disposition']!.contains('xls') ? 'xls' :
                response.headers['content-disposition']!.contains('docx') ? 'docx' :
                response.headers['content-disposition']!.contains('doc') ? 'doc' :
                response.headers['content-disposition']!.contains('json') ? 'json' : null
          );
        } else {
          throw HttpError.statusCode;
        }

      } catch(e){
        debugPrint('catch $e');
        bool r = e == HttpError.statusCode;
        return MyHttpResponse(
            isSucess: false,
            httpError: r ? HttpError.statusCode : HttpError.unexpected,
            codigo: response.statusCode,
            data: r ? response.body :  'Erro inesperado, tente novamente mais tarde'
        );
      }
    } catch (error) {
      debugPrint('onError $error');

      return MyHttpResponse(
          isSucess: false,
          httpError: error == HttpError.timeout ? HttpError.timeout : HttpError.unexpected,
          data: error == HttpError.timeout ?
          'Tempo limite de conexão excedido' :  'Erro inesperado, tente novamente mais tarde'
      );
    }
  }


  Future<MyHttpResponse> delete({required String url, Map<String, String>? headers,
    Map<String, dynamic>? body, bool decoder = false}) async {

    if(!connectionStatus.hasConnection){
      return MyHttpResponse(
          isSucess: false,
          httpError: HttpError.conection,
          data: 'Falha de conexão com internet'
      );
    }

    try {
      final http.Response response = await http.delete(
          Uri.parse(url),
          headers: headers ?? <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'charset': 'UTF-8',
          },
          body: jsonEncode(body)
      ).timeout(Duration(seconds: 60), onTimeout : () {
        debugPrint('delete timeout');
        throw HttpError.timeout;
      });

      try{
        if(response.statusCode >= 200 && response.statusCode < 300){
          final result = decoder ? json.decode(response.body) : response.body;
          return MyHttpResponse(
              isSucess: true,
              codigo: 200,
              data: result,
          );
        } else {
          debugPrint(response.body);
          throw HttpError.statusCode;
        }

      } catch(e){
        debugPrint('delete catch $e');
        bool r = e == HttpError.statusCode;
        return MyHttpResponse(
            isSucess: false,
            httpError: r ? HttpError.statusCode : HttpError.unexpected,
            codigo: response.statusCode,
            data: r ? response.body :  'Erro inesperado, tente novamente mais tarde'
        );
      }
    }  catch (error) {
      debugPrint('delete onError $error');
      return MyHttpResponse(
          isSucess: false,
          httpError: error == HttpError.timeout ? HttpError.timeout : HttpError.unexpected,
          data: error == HttpError.timeout ?
          'Tempo limite de conexão excedido' :  'Erro inesperado, tente novamente mais tarde'
      );
    }
  }
}