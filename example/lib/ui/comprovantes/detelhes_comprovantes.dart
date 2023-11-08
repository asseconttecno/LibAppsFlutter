import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

class DetalhesComprovantes extends StatefulWidget {
  Apontamento apontamento;

  DetalhesComprovantes(this.apontamento);

  @override
  _DetalhesComprovantesState createState() => _DetalhesComprovantesState();
}

class _DetalhesComprovantesState extends State<DetalhesComprovantes> {
  bool load = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - (WidgetsBinding.instance.window.padding.top);
    double width = MediaQuery.of(context).size.width;

    return Consumer<ComprovanteManagger>(
      builder: (_, comprovantes,__) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 70, color: Theme.of(context).scaffoldBackgroundColor))
            ),
            width: width,
            height: height,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: FutureBuilder<List<MarcacoesComprovanteModel>>(
                future: comprovantes.listarMarcacoes(
                    context.read<UserPontoManager>().usuario,
                    widget.apontamento
                ),
                builder: (_, snapshot){
                  Widget resultado;
                  switch( snapshot.connectionState ){
                    case ConnectionState.none :
                    case ConnectionState.waiting :
                      resultado = Center(
                        child: Container(
                            width: 50,
                            child: const LinearProgressIndicator(minHeight: 10, backgroundColor: Colors.transparent,)
                        ),
                      );
                      break;
                    case ConnectionState.active :
                    case ConnectionState.done :
                      if( snapshot.hasError || !snapshot.hasData || snapshot.data == null){
                        resultado = GestureDetector(
                            child: const Center(
                              child: Icon(Icons.autorenew_outlined,
                                color: Config.corPri, size: 70,),
                            ),
                            onTap: (){
                              setState(() {});
                            }
                        );
                      }else {
                        if(snapshot.data != null && snapshot.data!.isNotEmpty){
                          resultado =  ListView(
                            children: snapshot.data!.map((e) {
                              return Hero(
                                tag: 'File-${e.marcacaoId}',
                                child: InkWell(
                                  onTap: () async {
                                    carregar(context);
                                    Uint8List? file = await comprovantes.getPDF(context.read<UserPontoManager>().usuario, e.marcacaoId!);
                                    Navigator.pop(context);
                                    if(file != null){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=> FileHero('Comprovante de Ponto - ${DateFormat('dd-MM-yyy HH-mm', 'pt_BR').format(e.dataHora!)}',
                                            memori: file,
                                          )
                                      ));
                                    }else{
                                      CustomSnackbar.context(context, 'Não foi possivel gerar seu comprovante, tente novamente mais tarde!', Colors.red);
                                    }
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? const EdgeInsets.all(8.0) : EdgeInsets.zero ,
                                      child: ListTile(
                                        leading: Text(DateFormat('dd/MM\nE', 'pt_BR').format(e.dataHora!).toUpperCase()),
                                        title: Text('Horario da Marcação: ${DateFormat('HH:mm', 'pt_BR').format(e.dataHora!)}'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }else{
                          resultado = Center(child: CustomText.text('Nenhum comprovante disponivel'));
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
