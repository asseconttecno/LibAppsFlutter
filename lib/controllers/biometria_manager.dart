
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/services.dart';


class BiometriaManager extends ChangeNotifier {
  BiometriaServices _services = BiometriaServices();

  bool _perguntar = false;
  bool get perguntar => _perguntar;
  set perguntar(bool v){
    _perguntar = v;
    notifyListeners();
  }

  bool _bio = false;
  bool get bio => _bio;
  set bio(bool v){
    _bio = v;
    saveBiometria();
    notifyListeners();
  }

  bool _checkbio = false;
  bool get checkbio => _checkbio;
  set checkbio(bool v){
    _checkbio = v;
    notifyListeners();
  }

  saveBiometria() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("bio", bio);
      await prefs.setBool("perguntar", perguntar);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  loadBio() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      perguntar =  await prefs.getBool("perguntar") ?? false;
      bio = await prefs.getBool("bio") ?? false;
    } catch(e) {
      debugPrint(e.toString());
    }
    try{
      checkbio = await _services.checkBio();
    }catch(e) {
      debugPrint(e.toString());
    }
  }


}