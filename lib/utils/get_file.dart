
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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

  static Future<File> fileTemp(String extensao, {Uint8List? memori, String? base64})  async {
    assert(memori != null || base64 != null);

    String name = DateTime.now().microsecondsSinceEpoch.toString();
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${name}.$extensao').writeAsBytes(memori ?? base64Decode(base64!));
    return file;
  }
}