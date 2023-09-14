import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/ponto/foto.dart';


class CameraPontoManager extends ChangeNotifier {
  final CameraPontoService _service = CameraPontoService();

  Future<Uint8List?> getPhoto(UsuarioPonto user) async {
    Uint8List? img = await _service.getPhoto(user);
    return img;
  }

  Future<bool> setPhoto(UsuarioPonto user, List<int> img, String? faceId) async {
    bool result = await _service.setPhoto(user, img, faceId);
    return result;
  }


}