import 'dart:async';
import '../settintgs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:trust_location/trust_location.dart';


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
          if(!Settings.isIOS) TrustLocation.start(5) ;
          location.changeSettings(accuracy: LocationAccuracy.balanced);
          getLocalizacao();
        }else{
          locationData = null;
        }
      }catch (e){
        debugPrint(e.toString());
        locationData = null;
        //erro();
      }

  }

  getLocalizacao() async {
    try{
      if(Settings.isIOS){
        location.onLocationChanged.listen((event) {
          locationData = event;
          cam = CameraPosition(
              target: LatLng(locationData!.latitude!, locationData!.longitude!),
              zoom: 18
          );
          //notifyListeners();
        }).onError((handleError){
          debugPrint(handleError.toString());
          locationData = null;
        });
      }else {
        TrustLocation.onChange.listen((values) async {
          if((values.isMockLocation ?? false) && values.latitude != null && !kReleaseMode) {
              if(locationData == null || (locationData?.latitude != values.latitude
                  && locationData?.longitude != values.longitude)){
                locationData = LocationData.fromMap({
                  'latitude' : double?.tryParse(values.latitude!) ?? 0.0,
                  'longitude' : double?.tryParse(values.longitude!) ?? 0.0
                });
                cam = CameraPosition(
                    target: LatLng(locationData!.latitude!,locationData!.longitude!),
                    zoom: 18
                );
              }
              //notifyListeners();
          }else if((!(values.isMockLocation ?? false) && values.latitude == null) || !kReleaseMode) {
            LocationData _locationData = await location.getLocation();
            if(locationData == null || locationData != _locationData){
              locationData = _locationData;
              cam = CameraPosition(
                zoom: 18, target: LatLng(
                  locationData!.latitude!, locationData!.longitude!),
              );
              //notifyListeners();
            }
          }else{
            LocationData _locationData = await location.getLocation();
            if(locationData == null || locationData != _locationData){
              locationData = _locationData;
              cam = CameraPosition(
                zoom: 18, target: LatLng(
                  locationData!.latitude!, locationData!.longitude!),
              );
              //notifyListeners();
            }
          }
            /*location.onLocationChanged.listen((event) {
              if((!(values.isMockLocation ?? false) && values.latitude == null) || !kReleaseMode) {
                print(event);
                locationData = event;
                cam = CameraPosition(
                    target: LatLng(
                        locationData!.latitude!, locationData!.longitude!),
                    zoom: 18
                );
                notifyListeners();
              }
            }).onError((handleError){
              debugPrint('onLocationChanged.listen erro ' + handleError.toString());
              locationData = null;
            });*/

        }).onError((handleError){
          debugPrint('TrustLocation.listen erro ' + handleError.toString());
        });
      }
    }catch(e){
      debugPrint(e.toString());
      locationData = null;
    }
  }

  static Future<String?> getEndereco(double? latitude, double? longitude) async {
    if(latitude == null || longitude == null) return null;
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latitude, longitude);
    geo.Placemark place = placemarks.first;

    String endereco = '${place.street}, ${place.subThoroughfare} - ${place.subLocality}, ${place.subAdministrativeArea} - ${place.country}';
    return endereco;
  }
}