
import 'dart:async';

import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html_to_pdf_plus/flutter_html_to_pdf_plus.dart';
import 'package:path_provider/path_provider.dart';


class Conversoes {


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
         content: htmlContent, configuration: PrintPdfConfiguration(
            targetDirectory: tempDir.path, targetName: savedPath
          )
     );

     return file;
   }catch(e){
     debugPrint(e.toString());
   }
  }


  static Future<File?> fileHtmlToPdf({required File html, String? nome}) async {
    try{
      Directory tempDir = await getTemporaryDirectory();
      String savedPath = nome ?? DateTime.now().microsecondsSinceEpoch.toString();

      File? file = await FlutterHtmlToPdf.convertFromHtmlFile(
          htmlFile: html, configuration: PrintPdfConfiguration(
              targetDirectory: tempDir.path, targetName: savedPath
          )
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

}

