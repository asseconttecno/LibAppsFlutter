import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../model/model.dart';
import '../services/ponto/foto.dart';


class CameraManager extends ChangeNotifier {
  FotoService _service = FotoService();

  List<int>? _img;
  List<int>? get img => _img;
  set img(List<int>? v){
    _img = v;
    notifyListeners();
  }

  getPhoto(UsuarioPonto user) async {
    Uint8List? _list = await _service.getPhoto(user);
    if(_list != null) img = _list;
  }

  Future<bool> setPhoto(UsuarioPonto user, List<int> img, String? faceId) async {
    bool result = await _service.setPhoto(user, img, faceId);
    return result;
  }


}