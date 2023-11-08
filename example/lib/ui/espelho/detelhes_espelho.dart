import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:assecontservices/assecontservices.dart';

class DetalhesEspelho extends StatefulWidget {
  Apontamento apontamento;
  DetalhesEspelho(this.apontamento);

  @override
  _DetalhesEspelhoState createState() => _DetalhesEspelhoState();
}

class _DetalhesEspelhoState extends State<DetalhesEspelho> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        (WidgetsBinding.instance.window.padding.top);
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder<EspelhoModel?>(
        future: context.read<EspelhoManager>().postEspelhoPontoPDF(
            context.read<UserPontoManager>().usuario, widget.apontamento),
        builder: (_, snapshot) {
          Widget resultado;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              resultado = Center(
                child: Container(
                    width: 50,
                    child: const LinearProgressIndicator(
                      minHeight: 10,
                      backgroundColor: Colors.transparent,
                    )),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                resultado = GestureDetector(
                    child: Icon(
                      Icons.autorenew_outlined,
                      color: Config.corPri,
                      size: 60,
                    ),
                    onTap: () {
                      context.read<EspelhoManager>().postEspelhoPontoPDF(
                          context.read<UserPontoManager>().usuario,
                          widget.apontamento);
                    });
              } else {
                if (snapshot.data != null) {

                  resultado = Scaffold(
                    body: Center(
                      child: Container(
                          decoration: BoxDecoration(
                              border: snapshot.data?.data != null
                                  ? null
                                  : Border(
                                      bottom: BorderSide(
                                          width: 70,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor))),
                          width: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 600 : width,
                          height: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? null : height,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SfPdfViewer.memory(
                                            snapshot.data!.espelhoHtml!,
                                            enableDocumentLinkAnnotation: false,
                                            canShowPaginationDialog: false,
                                            enableDoubleTapZooming: false,
                                            enableTextSelection: false,
                                            canShowScrollStatus: false,
                                            canShowScrollHead: false,
                                            canShowPasswordDialog: false,
                                            pageSpacing: 4,
                                            interactionMode:
                                            PdfInteractionMode.pan),
                                        /*SingleChildScrollView(
                                          child: HtmlContentViewer(
                                            htmlContent: snapshot.data!.espelhoHtml ?? '',
                                            initialContentHeight: MediaQuery.of(context).size.height,
                                            initialContentWidth: MediaQuery.of(context).size.width,
                                          ),
                                        ),*/

                                        Hero(
                                          tag: 'File',
                                          child: GestureDetector(
                                            child: Center(
                                              child: Container(
                                                height: 80, width: double.infinity,
                                                alignment: Alignment.center,
                                                color: Colors.black26,
                                                child: Text('Clique aqui para baixar'),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FileHero('Espelho de Ponto - ${widget.apontamento.descricao}',
                                                            file: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? null : snapshot.data!.espelho!,
                                                            memori: snapshot.data!.espelhoHtml!,
                                                          )));
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (snapshot.data?.data != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: CustomText.text('Espelho Assinado em: ' +
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(snapshot.data!.data!)),
                                )
                            ],
                          )),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: snapshot.data?.data != null
                        ? null
                        : widget.apontamento.datatermino
                                    .compareTo(DateTime.now()) >=
                                0
                            ? null
                            : FloatingActionButton.extended(
                                backgroundColor: Config.corPri,
                                onPressed: () async {
                                  await CustomAlert.custom(
                                      context: context,
                                      titulo: 'Assinar Espelho de Ponto',
                                      corpo: Container(
                                        padding: const EdgeInsets.only(
                                            bottom: 20, top: 5),
                                        child: CustomText.text(
                                          'Esta deacordo com as informações\ndo espelho de ponto?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      txtBotaoSucess: 'CONFIRMAR',
                                      txtBotaoCancel: 'REJEITAR',
                                      funcSucess: () async {
                                        bool result = await context
                                            .read<EspelhoManager>()
                                            .postEspelhoStatus(
                                                context
                                                    .read<UserPontoManager>()
                                                    .usuario,
                                                widget.apontamento,
                                                true);
                                        if (result) {
                                          setState(() {});
                                          CustomAlert.sucess(
                                            context: context,
                                            mensage:
                                                'Espelho de ponto assinado.\n',
                                          );
                                        } else {
                                          CustomAlert.erro(
                                            context: context,
                                            mensage:
                                                'Não foi possivel assinar seu espelho\ntente novamente!',
                                          );
                                        }
                                      },
                                      funcCancel: () async {
                                        await context
                                            .read<EspelhoManager>()
                                            .postEspelhoStatus(
                                                context
                                                    .read<UserPontoManager>()
                                                    .usuario,
                                                widget.apontamento,
                                                false);
                                      });
                                },
                                label: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: CustomText.text(
                                    'ASSINAR',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                )),
                  );
                } else {
                  resultado = Center(
                      child: CustomText.text('Nenhum Espelho disponivel'));
                }
              }
              break;
          }
          return resultado;
        });
  }
}
