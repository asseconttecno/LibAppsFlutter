import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trust_location/trust_location.dart';
import 'package:assecontservices/assecontservices.dart';



class Gps extends ChangeNotifier {
  Location location = Location();
  LocationData? locationData;

  CameraPosition _cam = const CameraPosition(target: LatLng(-23.5505199, -46.6333094), zoom: 18);
  CameraPosition  get cam => _cam;
  set cam(CameraPosition c){
    _cam = c;
    notifyListeners();
  }

  Future<bool> get serviceEnabled async {
    return await location.serviceEnabled();
  }

  Future<bool> get isMockLocation async {
    return await TrustLocation.isMockLocation;
  }

  localizacao() async {
    PermissionStatus _permissionGranted;
    try{
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
      }

      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
      }

      if ((_permissionGranted == PermissionStatus.granted ||
          _permissionGranted == PermissionStatus.grantedLimited ) && _serviceEnabled) {
        //if(!Config.isIOS) TrustLocation.start(5) ;
        //location.changeConfig(accuracy: LocationAccuracy.balanced);
        getLocalizacao();
      }else{
        //locationData = null;
      }
    }catch (e){
      debugPrint(e.toString());
      //locationData = null;
      //erro();
    }
  }

  getLocalizacao() async {
    try{
      locationData = await location.getLocation();
      cam = CameraPosition(
          target: LatLng(locationData!.latitude!, locationData!.longitude!),
          zoom: 18
      );
    }catch(e){
      debugPrint(e.toString());
    }
  }

}