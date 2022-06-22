import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:trust_location/trust_location.dart';

import '../../config.dart';

class Gps extends ChangeNotifier {
  Location location = Location();
  LocationData? locationData;

  CameraPosition _cam = CameraPosition(target: LatLng(-23.5505199, -46.6333094), zoom: 18);
  CameraPosition  get cam => _cam;
  set cam(CameraPosition c){
    _cam = c;
    notifyListeners();
  }

  Future<bool> get serviceEnabled async {
    return await location.serviceEnabled();
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
        if(!Config.isIOS) TrustLocation.start(5) ;
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
      if(Config.isIOS){
        locationData = await location.getLocation();
        cam = CameraPosition(
            target: LatLng(locationData!.latitude!, locationData!.longitude!),
            zoom: 18
        );
      }else {
        bool isMockLocation = await TrustLocation.isMockLocation;
        if(isMockLocation){
          LatLongPosition position = await TrustLocation.onChange.first;
          if(position.latitude != null && position.longitude != null){
            locationData = LocationData.fromMap({
              'latitude' : double?.tryParse(position.latitude!) ?? 0.0,
              'longitude' : double?.tryParse(position.longitude!) ?? 0.0
            });
            cam = CameraPosition(
                target: LatLng(locationData!.latitude!,locationData!.longitude!),
                zoom: 18
            );
          }else{
            LocationData _locationData = await location.getLocation();
            locationData = _locationData;
            cam = CameraPosition(
              zoom: 18, target: LatLng(
                locationData!.latitude!, locationData!.longitude!),
            );
          }
        }else{
          LocationData _locationData = await location.getLocation();
          locationData = _locationData;
          cam = CameraPosition(
            zoom: 18, target: LatLng(
              locationData!.latitude!, locationData!.longitude!),
          );
        }
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  static Future<String?> getEndereco(double? latitude, double? longitude) async {
    if(latitude == null || longitude == null) return null;
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'pt_BR');
    geo.Placemark place = placemarks.first;

    String endereco = '${place.street}, ${place.subThoroughfare} - ${place.subLocality}, ${place.subAdministrativeArea} - ${place.country}';
    print(endereco);
    return endereco;
  }
}