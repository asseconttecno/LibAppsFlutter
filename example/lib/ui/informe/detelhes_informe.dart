import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:assecontservices/assecontservices.dart';

class DetalhesInformes extends StatefulWidget {
  @override
  _DetalhesInformesState createState() => _DetalhesInformesState();
}

class _DetalhesInformesState extends State<DetalhesInformes> {
  bool load = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - (WidgetsBinding.instance?.window.padding.top ?? 0);
    double width = MediaQuery.of(context).size.width;


    return Consumer<InformeManager>(
      builder: (_, informe,__) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 70, color: Theme.of(context).scaffoldBackgroundColor))
            ),
            width: width,
            height: height,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: FutureBuilder<File?>(
                future: informe.informeRendimentosPDF(
                    context.read<UserHoleriteManager>().user!,
                    int.tryParse(informe.competencia?.anoReferencia ?? "0")
                ),
                builder: (_, snapshot){
                  Widget resultado;
                  switch( snapshot.connectionState ){
                    case ConnectionState.none :
                    case ConnectionState.waiting :
                      resultado = Center(
                        child: Container(
                            width: 50,
                            child: LinearProgressIndicator(minHeight: 10, backgroundColor: Colors.transparent,)
                        ),
                      );
                      break;
                    case ConnectionState.active :
                    case ConnectionState.done :
                      if( snapshot.hasError || !snapshot.hasData || snapshot.data == null){
                        resultado = GestureDetector(
                            child: Icon(Icons.autorenew_outlined,
                              color: Config.corPri, size: 70,),
                            onTap: (){
                              informe.informeRendimentosPDF(
                                  context.read<UserHoleriteManager>().user!,
                                  int.tryParse(informe.competencia?.anoReferencia ?? "0")
                              );
                            }
                        );
                      }else {
                        if(snapshot.data != null){
                          resultado =  Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: Stack(
                                    children: [
                                      SfPdfViewer.file(
                                          snapshot.data!,
                                          enableDocumentLinkAnnotation: false,
                                          canShowPaginationDialog: false,
                                          enableDoubleTapZooming: false,
                                          enableTextSelection: false,
                                          canShowScrollStatus: false,
                                          canShowScrollHead: false,
                                          canShowPasswordDialog: false,
                                          //pageLayoutMode: PdfPageLayoutMode.single,
                                          interactionMode: PdfInteractionMode.pan
                                      ),
                                      Hero(
                                        tag: 'File',
                                        child: GestureDetector(
                                          onTap: () async {
                                            await Navigator.push(context, MaterialPageRoute(
                                                builder: (context)=> FileHero(snapshot.data!,
                                                    'Informe de Rendimentos - ${informe.competencia?.anoReferencia}')
                                            ));
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ),
                              SizedBox(height: 15,),
                              Text("Disponibilizado\n${informe.competencia?.disponiblizado ?? ''}", textAlign: TextAlign.center,),
                              SizedBox(height: 15,),
                              Text("Visualizado\n${informe.competencia?.visualizado ?? ''}", textAlign: TextAlign.center,),
                            ],
                          );
                        }else{
                          resultado = Center(child: Text('Nenhum Informe disponivel'));
                        }
                      }
                      break;
                  }
                  return resultado;
                }
            ),
          ),
        );
      }
    );
  }
}
