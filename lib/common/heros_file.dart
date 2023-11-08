
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:share_extend/share_extend.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:universal_io/io.dart';
import 'package:universal_html/html.dart' as html;

import '../config.dart';
import '../utils/get_file.dart';
import 'load_screen.dart';



class FileHero extends StatefulWidget {
  final File? file;
  final Uint8List? memori;
  final String? html;
  final String name;
  final Widget? menu;
  FileHero(this.name, {this.menu, this.file,this.memori, this.html});

  @override
  _FileHeroState createState() => _FileHeroState();
}

class _FileHeroState extends State<FileHero> {
  final GlobalKey _globalKey = GlobalKey();
  Directory? externalDirectory;

// Função para salvar/baixar um arquivo Uint8List
  void salvarArquivo(Uint8List data, String nomeArquivo) {
    // Cria um Blob com os dados Uint8List
    final blob = html.Blob([data]);

    // Cria uma URL para o Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Cria um elemento de ancoragem
    final anchor = html.AnchorElement(href: url)
      ..target = 'webdownload' // Define o alvo para 'webdownload'
      ..download = nomeArquivo // Define o nome do arquivo a ser baixado
      ..click(); // Simula um clique no elemento de ancoragem

    // Revoga a URL criada após o download
    html.Url.revokeObjectUrl(url);
  }

  Future<Uint8List?> _capturePng() async {
    try {
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    if(!kIsWeb && !Config.isIOS){
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
                  if(kIsWeb){
                    if(widget.memori != null){
                      salvarArquivo(widget.memori!, "${widget.name}.pdf");
                    }
                  }else if(widget.file != null){
                    ShareExtend.share(widget.file!.path, "file",
                        sharePanelTitle: "Enviar PDF",
                        subject: "${widget.name}.pdf");
                  }else{
                    carregar(context);
                    Uint8List? rawPath = widget.memori ?? await _capturePng();
                    Navigator.pop(context);
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
          body: Hero(
              tag: "File",
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 100 : null,
                    height: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - AppBar().preferredSize.height : null,
                    margin: widget.menu != null ? const EdgeInsets.only(bottom: 120) : null,
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: widget.memori != null ? SfPdfViewer.memory(widget.memori!, ) :
                    widget.file == null ? Container() : SfPdfViewer.file(widget.file!),
                  ),
                  menus()
                ],
              )
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