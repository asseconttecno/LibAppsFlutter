import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../config.dart';
import '../http/http.dart';


class PrimeiroAcessoHoleriteService {
  HttpCli _http = HttpCli();

  Future<PrimeiroAcessoHoleriteModel?> verificar({required String cnpj, required String registro, }) async {
    String _metodo = '/holerite/novo/verificar';
    try{
      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: <String, dynamic>{
            "Cnpj": cnpj,
            "Registro": registro
          }
      );

      if(response.isSucess){
        Map result = response.data;
        if(result.containsKey('id')){
          PrimeiroAcessoHoleriteModel acessoModel = PrimeiroAcessoHoleriteModel.fromMap(result);
          return acessoModel;
        }
        if(result.containsKey('iscliente')){
          if(result['iscliente']){
            throw 404;
          }else{
            throw 205;
          }
        }
      }
      throw HttpError.unexpected;
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case 404 :
          throw 'Funcionario não cadastrado, verifique os dados e tente novamente!';
        case 205 :
          throw 'Empresa não cadastrada!';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }

  Future<PrimeiroAcessoHoleriteModel?> esqueceuEmail(
      {required String cnpj, required String registro, required String cpf, }) async {
    String _metodo = '/holerite/novo/recadastro';
    try{
      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: <String, dynamic>{
            "Cnpj": cnpj,
            "Registro": registro,
            "Cpf": cpf.replaceAll(".", "").replaceAll("-", "")
          }
      );

      if(response.isSucess){
        Map result = response.data;
        if(result.containsKey('id')){
          PrimeiroAcessoHoleriteModel acessoModel = PrimeiroAcessoHoleriteModel.fromMap(result);
          return acessoModel;
        }
        if(result.containsKey('iscliente')){
          if(result['iscliente']){
            throw 404;
          }else{
            throw 205;
          }
        }
      }
      throw HttpError.unexpected;
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case 404 :
          throw 'Funcionario não cadastrado, verifique os dados e tente novamente!';
        case 205 :
          throw 'Empresa não cadastrada!';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }

  Future<bool> cadastrar({required int id, required String email, required String senha,
      required String cpf, String? cel,}) async {
    String _metodo = '/holerite/novo/cadastro';
    try{
      MyHttpResponse response = await _http.post(
          url: Config.conf.apiHoleriteEmail! + _metodo,
          body: {
            "Id": id,
            "Email": email,
            "Senha": senha,
            "Cel": cel,
            "Cpf": cpf.replaceAll(".", "").replaceAll("-", "")
          }
      );
      return response.isSucess;
    } catch (e){
      debugPrint(e.toString());
      switch(e){
        case HttpError.unexpected :
          throw 'Erro inesperado, tente novamente!';
        case HttpError.timeout :
          throw 'Tempo limite de login excedido, verifique sua internet!';
        case 404 :
          throw 'Funcionario não cadastrado, verifique os dados e tente novamente!';
        default:
          throw 'Erro inesperado, tente novamente!';
      }
    }
  }
}