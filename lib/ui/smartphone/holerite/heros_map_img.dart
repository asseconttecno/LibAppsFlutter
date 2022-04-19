import 'dart:io';
import '../../../settintgs.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HoleriteHero extends StatefulWidget {
  final File img;
  final int mes;
  final int ano;
  HoleriteHero(this.img, this.mes, this.ano);

  @override
  _HoleriteHeroState createState() => _HoleriteHeroState();
}

class _HoleriteHeroState extends State<HoleriteHero> {
  Directory? externalDirectory;

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void initState() {

    if(!Settings.isIOS){
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
              if(!Settings.isIOS)
                IconButton(icon: Icon(Icons.download_rounded, color: Colors.white,),
                  onPressed: () async {
                    String? appDocDir = await FilesystemPicker.open(
                      title: 'Selecione o local para salvar',
                      context: context,
                      rootDirectory: externalDirectory!,
                      fsType: FilesystemType.folder,
                      pickText: 'Salvar nesse local',
                      folderIconColor: Settings.corPribar,
                    );
                    if(appDocDir != null){
                      File down = await File(appDocDir + '/holerite-${widget.ano}-${widget.mes}.pdf').
                        writeAsBytes(widget.img.readAsBytesSync());
                      print(down.path);
                      OpenFile.open(down.path);
                    }
                  }
                ),
              IconButton(icon: Icon(Icons.send, color: Colors.white,),
                onPressed: (){
                  ShareExtend.share(widget.img.path, "file",
                      sharePanelTitle: "Enviar PDF",
                      subject: "holerite-${widget.ano}-${widget.mes}.pdf");
                }
              ),
            ],
          ),
          body: Stack(
            alignment: Alignment.topLeft,
            children:[
              Center(
                child: Hero(tag: "holerite",
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black,
                      child: SfPdfViewer.file(widget.img)
                    )
                ),
              ),
            ],
          )
    );
  }
}