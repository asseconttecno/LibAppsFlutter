import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';


class CameraService {
  static final _picker = ImagePicker();

  static Future<Uint8List?> getImage() async {
    File? image;
    Uint8List? img;
    try{
      await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxHeight: 1280,
        //imageQuality: 70,
      ).then((value) async {
          if(value != null){
            if(kIsWeb){
              img = await value.readAsBytes();
            }else{
              image = File(value.path);
              img = image!.readAsBytesSync();
            }
          }
        }
      ).catchError((onError){
        debugPrint(onError.toString());
      });
      return img;
    }catch (e){
      debugPrint('Erro camera $e');
      return null;
    }
  }

  static  Future<Uint8List?> getGallery() async {
    File? image ;
    Uint8List? img;
    try{
      await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxHeight: 1280,
      ).then((value) async {
            if(value != null){
              if(kIsWeb){
                img = await value.readAsBytes();
              }else{
                image = File(value.path);
                img = image!.readAsBytesSync();
              }
              //image.readAsStringSync(encoding: latin1);
            }
          }
      ).catchError((onError){
        debugPrint(onError.toString());
      });
      return img;
    }catch (e){
      debugPrint('Erro getGallery $e');
      return null;
    }
  }
}