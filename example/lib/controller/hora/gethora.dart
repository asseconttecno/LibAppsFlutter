
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class GetHora extends ChangeNotifier {
  GetHora(){
    atualizarhora();
  }
  static Timer? timer;
  String get horarioAtual => "${DateFormat('HH:mm').format(DateTime.now())}";

  atualizarhora() {
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer timer) {
          horarioAtual;
          notifyListeners();
        }
    );
  }
}