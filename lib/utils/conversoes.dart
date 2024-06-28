
import 'dart:async';

import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geocoding/geocoding.dart' as geo;


class Conversoes {
  Conversoes(){
    setLocale();
  }

  Future<void> setLocale() async {
    try{
      await geo.GeocodingPlatform.instance?.setLocaleIdentifier('pt_BR');
    }catch(e){}
  }

  static Future<File?> htmlToPdf({required String html, String? nome}) async {
   try{
     var htmlContent = '''<!DOCTYPE html>
        <html>
        <head></head>
        <body>${html}</body>
        </html>
        ''';

     Directory tempDir = await getTemporaryDirectory();
     String savedPath = nome ?? ("contrato - ${DateTime.now().microsecondsSinceEpoch}");
     File? file = await FlutterHtmlToPdf.convertFromHtmlContent(
         htmlContent, tempDir.path, savedPath
     );

     return file;
   }catch(e){
     debugPrint(e.toString());
   }
  }


  static double redimencionarTamanhos(double? widthOriginal, double? heightOriginal, double tamanhoNovo, bool newWidth){
    if(widthOriginal == null || heightOriginal == null) return 0;
    double result = 0;

    if(newWidth){
      result = (tamanhoNovo * heightOriginal) / widthOriginal;
    }else{
      result = (tamanhoNovo * widthOriginal) / heightOriginal;
    }
    return result;
  }



  static Future<String?> getEndereco(double? latitude, double? longitude) async {
    if(latitude == null || longitude == null) return null;
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latitude, longitude);
    if(placemarks.isNotEmpty){
      geo.Placemark place = placemarks.first;

      String endereco = '${place.street}, ${place.subThoroughfare} - ${place.subLocality}, ${place.subAdministrativeArea} - ${place.country}';

      return endereco;
    }
  }
}

