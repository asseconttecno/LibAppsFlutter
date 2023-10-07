
import 'package:universal_io/io.dart';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import '../../model/model.dart';
import '../../services/services.dart';


class ComprovanteManagger extends ChangeNotifier{
  final ComprovanteService _service = ComprovanteService();

  Future<List<MarcacoesComprovanteModel>> listarMarcacoes(UsuarioPonto? user, Apontamento aponta) async {
    List<MarcacoesComprovanteModel> list = [];
    list = await _service.postListarMarcacoes(user, aponta);
    return list;
  }

  Future<File?> getPDF(UsuarioPonto? user, int marcId) async {
    final file = await _service.postComprovantePDF(user, marcId);
    return file;
  }
}