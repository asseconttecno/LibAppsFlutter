import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../config.dart';
import '../utils/get_file.dart';
import 'load_screen.dart';

class FileHero extends StatefulWidget {
  final File? file;
  final String? html;
  final String name;
  final Widget? menu;
  FileHero(this.name, {this.menu, this.file, this.html});

  @override
  _FileHeroState createState() => _FileHeroState();
}

class _FileHeroState extends State<FileHero> {
  final GlobalKey _globalKey = GlobalKey();
  Directory? externalDirectory;

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    if(!Config.isIOS){
      getExternalStorageDirectory()
          .then((directory) => setState(() => externalDirectory = directory));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            actions: [
/*              if(!Config.isIOS)
                IconButton(icon: Icon(Icons.download_rounded, color: Colors.white,),
                  onPressed: () async {
                    String? appDocDir = await FilesystemPicker.open(
                      title: 'Selecione o local para salvar',
                      context: context,
                      rootDirectory: externalDirectory!,
                      fsType: FilesystemType.folder,
                      pickText: 'Salvar nesse local',
                      folderIconColor: Config.corPribar,
                    );
                    if(appDocDir != null){
                      File down = await File((appDocDir + '/${widget.name}.pdf').replaceAll(' ', '-')).
                      writeAsBytes(widget.file.readAsBytesSync());
                      print(down.path);
                      OpenFile.open(down.path);
                    }
                  }
                ),*/
              IconButton(icon: Icon(Icons.send, color: Colors.white,),
                onPressed: () async {
                  if(widget.file != null){
                    ShareExtend.share(widget.file!.path, "file",
                        sharePanelTitle: "Enviar PDF",
                        subject: "${widget.name}.pdf");
                  }else{
                    carregar(context);
                    Uint8List? rawPath = await _capturePng();
                    if(rawPath != null){
                      final file = await CustomFile.fileTemp('pdf', memori: rawPath, nome: widget.name);
                      ShareExtend.share(file.path, "file",
                          sharePanelTitle: "Enviar PDF",
                          subject: "${widget.name}.pdf");
                    }
                  }

                }
              ),
            ],
          ),
          body: Stack(
            alignment: Alignment.topLeft,
            children:[
              Center(
                child: Hero(
                    tag: "File",
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          //height: h - 100,
                          margin: widget.menu != null ? const EdgeInsets.only(bottom: 120) : null,
                          alignment: Alignment.center,
                          color: Colors.black,
                          child: widget.file == null ? Html(
                            key: _globalKey,
                            data: widget.html ?? '',
                          ) : SfPdfViewer.file(widget.file!),
                        ),
                        menus()
                      ],
                    )
                ),
              ),
            ],
          )
    );
  }

  Widget menus(){
    if(widget.menu != null){
      return Container(
        height: 120,
        child: widget.menu!);
    }
    return Container();
  }
}