import 'dart:convert';
import 'dart:io';
import '../../../settintgs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CustomCamera {
  final picker = ImagePicker();

  Future<File?> getImage() async {
    File? image;
    List<int> img;
    try{
      await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxHeight: 600,
        //imageQuality: 70,
      ).then((value) async {
          if(value != null){
            image = File(value.path);
            //img = image.readAsBytesSync();
          }
        }
      ).catchError((onError){
        debugPrint(onError.toString());
      });
      return image;
    }catch (e){
      debugPrint('Erro camera ' + e.toString());
      return null;
    }
  }

  Future<File?> getGallery() async {
    File? image ;
    List<int> img;
    if(!Settings.isWin){
      try{
        await picker.pickImage(
          source: ImageSource.gallery,
          //imageQuality: 70,
          maxHeight: 600,
        ).then(
                (value) async {
              if(value != null){
                image = File(value.path);
                //img = image.readAsBytesSync();
                //image.readAsStringSync(encoding: latin1);
              }
            }
        ).catchError((onError){
          debugPrint(onError.toString());
        });
        return image;
      }catch (e){
        debugPrint('Erro getGallery ' + e.toString());
        return null;
      }
    }else{
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image
        );
        if(result != null){
          image = File(result.files.single.path!);
          return image;
        }
      } on Exception catch (e) {
        debugPrint('Erro getGallery ' + e.toString());
        return null;
      }
    }
  }
}