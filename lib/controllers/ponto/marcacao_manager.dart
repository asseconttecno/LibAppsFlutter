import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';

import '../../config.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../controllers.dart';


class MarcacoesManager extends ChangeNotifier {
  final MarcacoesService _service = MarcacoesService();
  List<Marcacao> listamarcacao = [];
  List<DecorationItem> listdecoration = [];
  DateTime _data = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime get data => _data;
  set data(DateTime v){
    _data = DateTime(v.year, v.month, v.day);
    notifyListeners();
  }


  bool _load = true;
  bool get load => _load;
  set load(v){
    _load = v;
    notifyListeners();
  }

  MarcacaoManager(){
    marcacaoUpdate();
  }

  marcacaoUpdate(){
    getEspelho();
  }

  signOut(){
    listamarcacao = [];
  }

  Future<Marcacao?> getMarcacaoDia() async {
    Marcacao? _marcacao;
    try{
      if(listamarcacao.any((e) {
        if(e.datahora != null){
          return DateTime(e.datahora!.year, e.datahora!.month, e.datahora!.day) == data;
        }
        return false;
      })){
        _marcacao = listamarcacao.firstWhere((e) {
          if(e.datahora != null){
            return DateTime(e.datahora!.year, e.datahora!.month, e.datahora!.day) == data;
          }
          return false;
        });
      }
    }catch (e){
      debugPrint(e.toString());
    }
    return _marcacao;
  }

  getEspelho({int? filtro}) async {
    try{
      listamarcacao = await _service.getEspelho(UserPontoManager.susuario);
      if(listamarcacao.isNotEmpty){
        listamarcacao.map((element) {
          if(((element.resultado?.atrasosmin ?? 0) > 0 || (element.resultado?.faltasDias ?? 0) > 0)
              && (element.resultado?.extrasmin ?? 0) > 0){
            listdecoration.add(
                DecorationItem(
                    decoration: Icon(Icons.circle, color: Config.corPri,),
                    date: element.datahora
                )
            );
          }else if((element.resultado?.atrasosmin ?? 0) > 0 || (element.resultado?.faltasDias ?? 0) > 0){
            listdecoration.add(
                DecorationItem(
                    decoration: const Icon(Icons.circle, color: Colors.red,),
                    date: element.datahora
                )
            );

          }else if((element.resultado?.extrasmin ?? 0) > 0){
            listdecoration.add(
                DecorationItem(
                    decoration: const Icon(Icons.circle, color: Colors.green,),
                    date: element.datahora
                )
            );
          }else if((element.resultado?.abonosmin ?? 0) > 0){
            listdecoration.add(
                DecorationItem(
                    decoration: const Icon(Icons.circle, color: Colors.white,),
                    date: element.datahora
                )
            );
          }
        }).toList();
        if(filtro != null){
          DateTime? _d = listamarcacao.lastWhere((element) {
            if(filtro == 1 && (element.resultado?.atrasosmin ?? 0) > 0){
              return true;
            }else if(filtro == 2 && (element.resultado?.extrasmin ?? 0 ) > 0){
              return true;
            }else if(filtro == 3 && (element.resultado?.abonosmin ?? 0 ) > 0){
              return true;
            }else if(filtro == 4 && (element.resultado?.faltasDias ?? 0 ) > 0){
              return true;
            }else{
              return false;
            }
          }).datahora;
          if(_d != null){
            _data = DateTime(_d.year, _d.month, _d.day);
          }else{
            _data = DateTime(listamarcacao.last.datahora!.year, listamarcacao.last.datahora!.month, listamarcacao.last.datahora!.day);
          }
        }
        else if(listamarcacao.last.datahora != null &&
            DateTime(listamarcacao.last.datahora!.year, listamarcacao.last.datahora!.month, listamarcacao.last.datahora!.day).compareTo(_data) < 0){
          _data = DateTime(listamarcacao.last.datahora!.year, listamarcacao.last.datahora!.month, listamarcacao.last.datahora!.day);
        }
      }
      notifyListeners();
    }catch(e){
      debugPrint("MarcacoesManager getEspelho Erro Try ${e.toString()}");
    }
  }


}