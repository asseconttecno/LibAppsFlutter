import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';

import '../../config.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class MarcacoesManager extends ChangeNotifier {
  final MarcacoesService _service = MarcacoesService();

  DateTime _data = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime get data => _data;
  set data(DateTime v){
    _data = DateTime(v.year, v.month, v.day);
    notifyListeners();
  }

  Future<ApontamentoDiaModel?> getMarcacaoDia() async {
    return await _service.getEspelho(UserPontoManager.susuario, data);
  }
}