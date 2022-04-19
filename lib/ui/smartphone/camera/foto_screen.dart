import 'dart:io';
import 'dart:typed_data';
import '../../../common/load_screen.dart';
import '../../../services/camera/camera_manager.dart';
import '../../../settintgs.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

import 'camera.dart';

class ImageHero extends StatefulWidget {
  List<int>? foto;

  ImageHero(this.foto);

  @override
  _ImageHeroState createState() => _ImageHeroState();
}

class _ImageHeroState extends State<ImageHero> {
  @override
  Widget build(BuildContext context) {

    return Hero(tag: "foto",
      child: Scaffold(backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Stack(alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    //height: MediaQuery.of(context).size.height * 0.78,
                    color: Colors.black,
                    child: widget.foto != null ? PhotoView(
                        imageProvider: MemoryImage( Uint8List.fromList(widget.foto!)  )
                    ) : Container(),
                  ),

                  Container(height: 80, color: Colors.black,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if(!Settings.isWin)
                        GestureDetector(
                          onTap: () async {
                            File? img = await CustomCamera().getImage();
                            if(img != null){
                              carregar(context);
                              await context.read<CameraManager>().atualizarFoto(
                                  img.readAsBytesSync(),
                                  onSuccess: () {
                                    context.read<CameraManager>().img = img.readAsBytesSync();
                                    Navigator.pop(context);
                                    Navigator.pop(context, context.read<CameraManager>().img);
                                  },
                                  onFail: (s) {
                                    Navigator.pop(context);
                                    WarningAlertBox(
                                        context: context,
                                        title: 'Falha',
                                        messageText: s,
                                        buttonText: 'ok'
                                    );
                                  }
                              );
                            }
                          },
                          child: Icon(Icons.camera, color: Colors.white, size: 50,),
                        ),
                        //SizedBox(width: 27,),
                        GestureDetector(
                          onTap: () async {
                            File? img = await CustomCamera().getGallery();
                            if(img != null){
                              carregar(context);
                              await context.read<CameraManager>().atualizarFoto(
                                  img.readAsBytesSync(),
                                  onSuccess: () {
                                    context.read<CameraManager>().img = img.readAsBytesSync();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  onFail: (s) {
                                    Navigator.pop(context);
                                    WarningAlertBox(
                                        context: context,
                                        title: 'Falha',
                                        messageText: s,
                                        buttonText: 'ok'
                                    );
                                  }
                              );
                            }
                          },
                          child: Icon(Icons.add_photo_alternate, color: Colors.white, size: 50,),
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: 20,),
              ]),
      ),
    );
  }
}

/*
class ImageHero extends StatefulWidget {
  var foto;

  ImageHero(this.foto);

  @override
  _ImageHeroState createState() => _ImageHeroState();
}

class _ImageHeroState extends State<ImageHero> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Hero(tag: "foto",
      child: Scaffold(backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Container(height: orientation != Orientation.landscape ? height * 0.865 : null,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: MediaQuery.of(context).size.height * 0.78,
                    color: Colors.black,
                    child: PhotoView(
                        imageProvider: MemoryImage(  base64Decode( widget.foto ))
                    ),
                  ),

                  Container(height: 50, color: Colors.black,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            List<int> img = await CustomCamera().getImage();
                            if(img != null){
                              await context.read<CameraManager>().setPhoto(
                                  img,
                                  onSuccess: () {
                                    context.read<HomeManager>().updateImg( base64Encode(img) );
                                    Navigator.pop(context);
                                  },
                                  onFail: (s, c) {
                                    WarningAlertBox(
                                        context: context,
                                        title: 'Falha',
                                        messageText: s,
                                        buttonText: 'ok'
                                    );
                                  }
                              );
                            }
                          },
                          child: Icon(Icons.camera, color: Colors.white, size: 50,),
                        ),
                        SizedBox(width: 50,),
                        GestureDetector(
                          onTap: () async {
                            List<int> img = await CustomCamera().getGallery();
                            if(img != null){
                              await context.read<CameraManager>().setPhoto(
                                  img,
                                  onSuccess: () {
                                    context.read<HomeManager>().updateImg( base64Encode(img) );
                                    Navigator.pop(context);
                                  },
                                  onFail: (s, c) {
                                    WarningAlertBox(
                                        context: context,
                                        title: 'Falha',
                                        messageText: s,
                                        buttonText: 'ok'
                                    );
                                  }
                              );
                            }
                          },
                          child: Icon(Icons.add_photo_alternate, color: Colors.white, size: 50,),
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: 20,),
              ]),
            ),
          )
      ),
    );
  }
}


 */