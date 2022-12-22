import 'dart:io';
import 'package:flutter/material.dart';

import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../config.dart';

class FileHero extends StatefulWidget {
  final File file;

  final String name;
  final Widget? menu;
  FileHero(this.file, this.name, {this.menu});

  @override
  _FileHeroState createState() => _FileHeroState();
}

class _FileHeroState extends State<FileHero> {
  Directory? externalDirectory;


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
              if(!Config.isIOS)
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
                ),
              IconButton(icon: Icon(Icons.send, color: Colors.white,),
                onPressed: (){
                  ShareExtend.share(widget.file.path, "file",
                      sharePanelTitle: "Enviar PDF",
                      subject: "${widget.name}.pdf");
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
                          margin: widget.menu != null ? EdgeInsets.only(bottom: 120) : null,
                          alignment: Alignment.center,
                          color: Colors.black,
                          child: SfPdfViewer.file(widget.file),
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