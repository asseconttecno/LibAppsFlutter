import 'dart:convert';
import 'package:universal_io/io.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../config.dart';
import 'services.dart';

class SendMail extends Services {

  Future<bool> postSendMail(String email, String corpo, File? file) async {
    String _api = '/email/sendMail';

    Map<String, dynamic> body = {
      "Email": email,
      "Body": "<p><b><span>Prezado Usuário,</span></b></p><p><b><span>$corpo</span></b></p><br><br>",
    };

    if(file != null){
      String _fileNome = file.path.split('/').last;
      String _nome = _fileNome.split('.').first;
      String _extensao = _fileNome.split('.').last;
      Uint8List list = await file.readAsBytes();
      String _fileBase64 = base64Encode(list);

      body["anexo"] = [
        {
          "file": _fileBase64,
          "nome": _nome,
          "extensao": _extensao
        }
      ];
    }
    //print(body);
    try{
      final response = await http.post(
        url: Config.conf.apiHolerite! + _api, decoder: false,
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      return response.isSucess;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}