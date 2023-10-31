import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';
import 'package:photo_view/photo_view.dart';

class ImageHero extends StatefulWidget {
  List<int>? foto;

  ImageHero(this.foto);

  @override
  _ImageHeroState createState() => _ImageHeroState();
}

class _ImageHeroState extends State<ImageHero> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "foto",
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          Container(
            //height: MediaQuery.of(context).size.height * 0.78,
            color: Colors.black,
            child: widget.foto != null
                ? PhotoView(
                    imageProvider:
                        MemoryImage(Uint8List.fromList(widget.foto!)))
                : Container(),
          ),

          Container(
            height: 80,
            color: Colors.black,
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!Config.isWin)
                  GestureDetector(
                    onTap: () async {
                      Uint8List? img = await CameraService.getImage();
                      if (img != null) {
                        carregar(context);
                        bool result = await context
                            .read<CameraPontoManager>()
                            .setPhoto(context.read<UserPontoManager>().usuario!,
                                img, null);
                        if (result) {
                          context
                              .read<UserPontoManager>()
                              .usuario
                              ?.funcionario
                              ?.foto = base64Encode(img);
                          Navigator.pop(context);
                          Navigator.pop(
                              context,
                              context
                                  .read<UserPontoManager>()
                                  .usuario
                                  ?.funcionario
                                  ?.foto);
                        } else {
                          Navigator.pop(context);
                          CustomAlert.erro(
                            context: context,
                            mensage:
                                'Não foi possivel atualizar sua foto, tente novamente mais tarde!',
                          );
                        }
                      }
                    },
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                //SizedBox(width: 27,),
                GestureDetector(
                  onTap: () async {
                    Uint8List? img = await CameraService.getGallery();

                    if (img != null) {
                      carregar(context);
                      bool result = await context
                          .read<CameraPontoManager>()
                          .setPhoto(context.read<UserPontoManager>().usuario!,
                              img, null);
                      if (result) {
                        context
                            .read<UserPontoManager>()
                            .usuario
                            ?.funcionario
                            ?.foto = base64Encode(img);
                        Navigator.pop(context);
                        Navigator.pop(
                            context,
                            context
                                .read<UserPontoManager>()
                                .usuario
                                ?.funcionario
                                ?.foto);
                      } else {
                        Navigator.pop(context);
                        CustomAlert.erro(
                          context: context,
                          mensage:
                              'Não foi possivel atualizar sua foto, tente novamente mais tarde!',
                        );
                      }
                    }
                  },
                  child: const Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                    size: 50,
                  ),
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