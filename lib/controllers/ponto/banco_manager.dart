
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';

import '../../config.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';

class BancoHorasManager extends ChangeNotifier {
  final BancoHorasService _service = BancoHorasService();

  List<BancoDiasList> listabanco = [];
  List<DecorationItem> listdecoration = [];
  DateTime _data = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime get data => _data;
  set data(DateTime v){
    _data = DateTime(v.year, v.month, v.day);
    notifyListeners();
  }

  BancoHorasManager(){
    bancoUpdate();
  }

  bancoUpdate(){
    getFuncionarioHistorico();
  }

  signOut(){
    listabanco = [];
  }


  Future<BancoDiasList?> getBancodia() async {
    BancoDiasList? bancoHoras;
    try{
      if(listabanco.any((e) {
        if(e.data != null){
          return DateTime(e.data!.year, e.data!.month, e.data!.day) == data;
        }
        return false;
      })){
          bancoHoras = listabanco.firstWhere((e) {
            if(e.data != null){
              return DateTime(e.data!.year, e.data!.month, e.data!.day) == data;
            }
            return false;
          });
      }
    }catch (e){
      debugPrint(e.toString());
    }
    return bancoHoras;
  }

  getFuncionarioHistorico() async {
    try{
      listabanco = await _service.getFuncionarioHistorico(UserPontoManager.susuario);
      if(listabanco.isNotEmpty){
        listabanco.map((element) {
          if((element.debitomin) > 0 && (element.creditomin) > 0){
            listdecoration.add(
                DecorationItem(
                    decoration: const Icon(Icons.circle, color: Config.corPri,),
                    date: element.data
                )
            );
          }else  if((element.creditomin) > 0){
            listdecoration.add(
                DecorationItem(
                    decoration: const Icon(Icons.circle, color: Colors.green,),
                    date: element.data
                )
            );
          }else if((element.lancamentos ?? '') != ''){
            listdecoration.add(
                DecorationItem(
                    decoration: const Icon(Icons.circle, color: Colors.amber,),
                    date: element.data
                )
            );

          }else if((element.debitomin) > 0 ){
            if(element.data != null && element.data!.compareTo(DateTime.now()) <= 0) {
              listdecoration.add(
                  DecorationItem(
                      decoration: const Icon(Icons.circle, color: Colors.red,),
                      date: element.data
                  )
              );
            }
          }
          return element;
        }).toList();
        if(listabanco.last.data != null && DateTime(listabanco.last.data!.year, listabanco.last.data!.month, listabanco.last.data!.day).compareTo(_data) < 0){
          _data = DateTime(listabanco.last.data!.year, listabanco.last.data!.month, listabanco.last.data!.day);
        }
      }
      notifyListeners();
    }catch(e){
      debugPrint("Erro Try ${e.toString()}");
    }
  }

}