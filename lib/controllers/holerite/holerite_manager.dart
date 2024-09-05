import 'dart:typed_data';

import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../services/services.dart';



class HoleriteManager extends ChangeNotifier {
  final HoleriteService _service = HoleriteService();

  HoleriteModel? holerites;
  List<DatumHolerite> get listHolerites => holerites?.data ?? [];


  bool _load = false;
  bool get load => _load;
  set load(bool v){
    _load = v;
    notifyListeners();
  }

  int _page = 0;
  int get page => _page;
  set page(int v){
    _page = v;
    notifyListeners();
  }
  
  int _pageSize = 3;
  int get pageSize => _pageSize;
  set pageSize(int v){
    if(_pageSize != v){
      _page = 0;
      _pageSize = v;
      listHolerite();
      notifyListeners();
    }
  }

  Future<void> init({bool update = false}) async {
    if(listHolerites.isNotEmpty && !update) return;
    _page = 0;
    _pageSize = 3;
    _load = true;
    await listHolerite(isLoad: false);
  }

  List<ChartColum> filtroHolerite(DatumHolerite holerite, int filtro){
    final l = listHolerites.where((e) => e.attributes?.type == holerite.attributes?.type).toList();
    int end = l.indexWhere((e) => e.id == holerite.id);
    int start = 0;
    if(end+1 - filtro > 0){
      start = end+1 - filtro;
    }
    final list = l.getRange(start, end+1).toList();
    return list.map((e)
    => ChartColum(e.id ?? 0, '${e.attributes?.competence ?? ''}\n${e.id ?? 0}',
        e.attributes?.data?.funcionarioResumo?.liquido ?? 0)).toList();
  }

  DatumHolerite selectHolerite(int id) => listHolerites.firstWhere((e) => e.id == id);


  Future<void> listHolerite({bool isLoad = true}) async {
    if(isLoad) load = true;
    final result = await _service.listHolerite(_page, _pageSize);
    holerites = result;
    holerites!.data?.sort((a, b) {
      try {
        if (a.attributes!.year != b.attributes!.year) {
          return b.attributes!.year!.compareTo(a.attributes!.year!);
        } else {
          return b.attributes!.month!.compareTo(a.attributes!.month!);
        }
      } catch (e) {
        return 999;
      }
    });

    load = false;
    notifyListeners();
  }

  Future<void> newPageHolerite() async {
    _page += 1;
    final result = await _service.newPageHolerite(_page, _pageSize);
    if(result.isNotEmpty){
      holerites?.data?.addAll(result);
      notifyListeners();
    }
  }

  Future<Uint8List?> holeriteresumoBytes(int? idholerite) async {
    try {
      Uint8List? result = await _service.holeriteresumoBytes(idholerite);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}