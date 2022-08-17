import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/common.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class MemorandosManager extends ChangeNotifier {
  MemorandosServices _services = MemorandosServices();

  List<Memorandos> memorandos = [];

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

  File? _foto;
  File? get foto => _foto;
  set foto(File? img){
    _foto = img;
    notifyListeners();
  }

  String _dropdownValue = "Atestado";
  String get dropdownValue => _dropdownValue;
  set dropdownValue(String v){
    _dropdownValue = v;
    notifyListeners();
  }

  TextEditingController controlerData =
  TextEditingController(text: DateFormat("dd/MM/yyyy").format(DateTime.now()));


  MemorandosManager(){
    memorandosUpdate();
  }

  memorandosUpdate(){
    if(UserPontoManager().usuario != null){
      getMemorandos(UserPontoManager().usuario!,
          UserPontoManager().usuario!.aponta!.datainicio,
          UserPontoManager().usuario!.aponta!.datatermino);
    }
  }

  signOut(){
    memorandos = [];
  }

  postMemorando(BuildContext context, UsuarioPonto usuario, DateTime data,
      String texto, int tipo ,{File? img, List<String>? marcacao}) async {

    bool result = await _services.postMemorando(usuario, data, texto, tipo);
    if(result){
      await Future.delayed(Duration(milliseconds: 100));
      memorandosUpdate();
      CustomAlert.sucess(
        context: context,
        mensage: 'Solicitação realizada!',
      );
    } else {
      CustomAlert.erro(
        context: context,
        mensage: 'Não foi possivel realizar a solicitação!',
      );
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
