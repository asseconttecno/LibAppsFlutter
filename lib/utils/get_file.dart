
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';

import '../services/http/http_cliente.dart';


class CustomFile {

  static Future<File> getFileUrl(String url) async {
    final responseData = await HttpCli().get(url: url, bits: true);

    var buffer = responseData.data.buffer;
    ByteData byteData = ByteData.view(buffer);
    String name = DateTime.now().microsecondsSinceEpoch.toString();
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${name}').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  static Future<File> fileTemp(String extensao, {Uint8List? memori, String? base64, String? nome })  async {
    assert(memori != null || base64 != null);

    String name = nome ?? DateTime.now().microsecondsSinceEpoch.toString();
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${name}.$extensao').writeAsBytes(memori ?? base64Decode(base64!));
    return file;
  }

  static Future<File> contentHtml(String nomeFile, {String? html})  async {
    var htmlContent = '''<!DOCTYPE html>
        <html>
        <head></head>
        <body>${html}</body>
        </html>
        ''';
    Directory tempDir = await getTemporaryDirectory();
    File? file = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, tempDir.path, nomeFile
    );
    return file;
  }

  static Future<File> fileHtml( File html,{String? nomeFile,})  async {
    String name = nomeFile ?? DateTime.now().microsecondsSinceEpoch.toString();

    Directory tempDir = await getTemporaryDirectory();
    File? file = await FlutterHtmlToPdf.convertFromHtmlFile(
        html, tempDir.path, name
    );
    return file;
  }
}