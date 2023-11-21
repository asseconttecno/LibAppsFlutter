import 'dart:typed_data';

import 'package:universal_io/io.dart';
import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/common.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class MemorandosManager extends ChangeNotifier {
  MemorandosServices _services = MemorandosServices();

  List<Memorandos> memorandos = [];
  List<Memorandos> memorandoDia(DateTime? date) => memorandos.where((e) => e.data == date).toList();


  bool _load = true;
  bool get load => _load;
  set load(v){
    _load = v;
    notifyListeners();
  }

  List<String> justPadrao = [
    "Solicito o abono de meus atrasos ou faltas neste dia",
    'Solicito a inclusão das seguintes marcações neste dia'
  ];

  final TextEditingController controlerObs = TextEditingController(
      text: "Solicito o abono de meus atrasos ou faltas neste dia");

  updateObs(bool marc){
    if(marc && controlerObs.text == justPadrao.first){
      controlerObs.text = justPadrao.last;
    }else if(!marc && controlerObs.text == justPadrao.last){
      controlerObs.text = justPadrao.first;
    }
  }

  Uint8List? _foto;
  Uint8List? get foto => _foto;
  set foto(Uint8List? img){
    _foto = img;
    notifyListeners();
  }

  String _dropdownValue = "Abono";
  String get dropdownValue => _dropdownValue;
  set dropdownValue(String v){
    _dropdownValue = v;
    notifyListeners();
  }

  TextEditingController controlerData =
  TextEditingController(text: DateFormat("dd/MM/yyyy").format(DateTime.now()));

  memorandosUpdate(){
    if(UserPontoManager().usuario != null){
      getMemorandos(
          UserPontoManager().usuario!,
          UserPontoManager.susuario!.periodo!.dataInicial!,
          UserPontoManager.susuario!.periodo!.dataFinal!
      );
    }
  }

  signOut(){
    memorandos = [];
  }

  Future<void> postMemorando(BuildContext context, UsuarioPonto usuario, DateTime data,
      String texto, int tipo ,{Uint8List? img, List<String>? marcacao}) async {

    bool result = await _services.postMemorando(usuario, data, texto, tipo, marcacao: marcacao, img: img);
    if(result){
      await Future.delayed(Duration(milliseconds: 100));
      memorandosUpdate();
      await CustomSnackbar.context(context, 'Solicitação realizada!', Colors.green);
    } else {
      await CustomSnackbar.context(context, 'Não foi possivel realizar a solicitação!', Colors.red);
    }
  }

  getMemorandos(UsuarioPonto usuario, DateTime inicio, DateTime fim) async {
    try{
      memorandos = await _services.getMemorandos(usuario, inicio, fim);
      notifyListeners();
    }catch(e){
      debugPrint("MemorandosManager getMemorandos Erro Try ${e.toString()}");
    }
  }
}
