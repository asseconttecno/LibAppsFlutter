import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common;
import 'package:charts_common/src/common/color.dart' as colors;



import '../../../common/common.dart';
import '../../../config.dart';
import '../../../controllers/controllers.dart';
import '../../../model/model.dart';


class DetalhesHolerite extends StatefulWidget {
  final List<HoleriteModel> holerite;
  final int idComp;
  final int mes;
  final int ano;
  DetalhesHolerite(this.holerite, this.idComp, this.mes, this.ano);

  @override
  _DetalhesHoleriteState createState() => _DetalhesHoleriteState();
}

class _DetalhesHoleriteState extends State<DetalhesHolerite> {
  bool load = false;
  HoleriteModel? holerite;
  var mask = NumberFormat.currency(locale: 'pt_Br', customPattern: 'R\$#,##0.00');

  init(){
    if(context.read<HoleriteManager>().dropdowntipo != ''){
      List<HoleriteModel>? _temp  = widget.holerite.where((e) =>
        e.holeriteTipo == context.read<HoleriteManager>().dropdowntipo).toList();
      if(_temp.isNotEmpty){
        holerite = _temp.first;
      }
    }
    if(widget.holerite.isNotEmpty){
      holerite ??= widget.holerite.first;
      context.read<HoleriteManager>().dropdowntipoInit(holerite?.holeriteTipo ?? '');
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }


  double getPorcentagem(double valor, double total){
    if(total == 0){
      return 0.0;
    }
    double result = 0;
    try{
      result = (valor/total) * 100.0;
    }catch(e){
      result = 0;
    }
    return double.parse(result.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - (WidgetsBinding.instance.window.padding.top);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 70,
                color: Theme.of(context).scaffoldBackgroundColor))
        ),
        width: width,
        height: height,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              if(kIsWeb)
              Row(
                mainAxisAlignment: !ResponsiveBreakpoints.of(context).isMobile
                    && !ResponsiveBreakpoints.of(context).isPhone ?
                    width >= 1500 ?  MainAxisAlignment.center :
                    MainAxisAlignment.end : MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    margin: const EdgeInsets.symmetric(horizontal: 40,),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    constraints: BoxConstraints(
                        maxWidth: !ResponsiveBreakpoints.of(context).isMobile
                            && !ResponsiveBreakpoints.of(context).isPhone
                            ? width >= 1052 ? 400 : 200 : 250 ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey, width: 1)
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: context.watch<HoleriteManager>().dropdowntipo,
                      iconSize: 20,
                      elevation: 0,
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                      style: TextStyle(color: Colors.black),
                      underline: Container(),
                      onChanged: (newValue) async {
                        setState(() {
                          context.read<HoleriteManager>().dropdowntipo = newValue!;
                          holerite = widget.holerite.firstWhere((e) => e.holeriteTipo == newValue);
                        });
                      },
                      items: widget.holerite.map((e) => e.holeriteTipo).toList()
                          .map<DropdownMenuItem<String>>(( value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding:  const EdgeInsets.symmetric(vertical: 8),
                            child: CustomText.text(value ?? ''),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              if(kIsWeb)
                SizedBox(height: 20,),

              if(!kIsWeb)
                Container(
                  height: 35,
                  margin: const EdgeInsets.symmetric(horizontal: 40,),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 1)
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: context.watch<HoleriteManager>().dropdowntipo,
                    iconSize: 20,
                    elevation: 0,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                    style: TextStyle(color: Colors.black),
                    underline: Container(),
                    onChanged: (newValue) async {
                      setState(() {
                        context.read<HoleriteManager>().dropdowntipo = newValue!;
                        holerite = widget.holerite.firstWhere((e) => e.holeriteTipo == newValue);
                      });
                    },
                    items: widget.holerite.map((e) => e.holeriteTipo).toList()
                        .map<DropdownMenuItem<String>>(( value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding:  const EdgeInsets.symmetric(vertical: 8),
                          child: CustomText.text(value ?? ''),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              Container(
                height: 195, width: width,
                padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                        && !ResponsiveBreakpoints.of(context).isPhone ? 20 : 0),
                decoration: BoxDecoration(
                  color: kIsWeb ?  Colors.white : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 110,
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                              && !ResponsiveBreakpoints.of(context).isPhone ? 40 : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: CustomText.text("Proventos\n${mask.format(holerite?.vencimentos ?? 0)}",
                                textAlign: TextAlign.center, autoSize: true,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.red[900],
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: CustomText.text("Descontos\n${mask.format(holerite?.descontos ?? 0)}",
                                textAlign: TextAlign.center, autoSize: true,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: CustomText.text("Liquido\n${mask.format(holerite?.liquido ?? 0)}",
                                textAlign: TextAlign.center, autoSize: true,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                        width: width * 0.59  > width - 110 ? width - 110 : width * 0.59,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText.text('Proventos'.toUpperCase(),
                            style: const TextStyle(color: Colors.black),),
                            const SizedBox(height: 4,),
                            Container(
                              height: 138,
                              constraints: kIsWeb
                                  && !ResponsiveBreakpoints.of(context).isMobile
                                  && !ResponsiveBreakpoints.of(context).isPhone ? BoxConstraints(maxWidth: width >= 852 ? 400 : 300) : null,
                              child: charts.PieChart<String>([charts.Series<ChartPizza, String>(
                                  id: 'Pizza',
                                  domainFn: (ChartPizza sales, _) => sales.desc,
                                  measureFn: (ChartPizza sales, _) => sales.valor,
                                  colorFn: (ChartPizza sales, cor) {
                                    if(sales.desc != 'Proventos'){
                                      return colors.Color.fromHex( code: 'fFF9800');
                                    }else{
                                      return colors.Color.fromHex( code: 'f0D47A1');
                                    }
                                  },
                                  data: [
                                    ChartPizza('Proventos',
                                      getPorcentagem(holerite?.vencimentos ?? 10.0,
                                          holerite?.vencimentos != null && holerite?.liquido != null
                                              ? (holerite?.vencimentos ?? 0) + (holerite?.liquido ?? 0) :
                                          holerite?.vencimentos != null || holerite?.liquido != null
                                              ? (holerite?.vencimentos ?? 0) + (holerite?.liquido ?? 0) : 100.0),
                                    ),
                                    ChartPizza('Liquido',
                                      getPorcentagem(holerite?.liquido ?? 0.0,
                                          holerite?.vencimentos != null && holerite?.liquido != null
                                              ? (holerite?.vencimentos ?? 0) + (holerite?.liquido ?? 0) :
                                          holerite?.vencimentos != null || holerite?.liquido != null
                                              ? (holerite?.vencimentos ?? 0) + (holerite?.liquido ?? 0) : 100.0),)
                                  ],
                                  labelAccessorFn: (ChartPizza sales, _) => '${sales.valor.toString()}%')
                              ],
                                  animate: true,
                                  layoutConfig: charts.LayoutConfig(
                                    leftMarginSpec: common.MarginSpec.fixedPixel(0),
                                    rightMarginSpec: common.MarginSpec.fixedPixel(0),
                                    topMarginSpec: common.MarginSpec.fixedPixel(12),
                                    bottomMarginSpec: common.MarginSpec.fixedPixel(2),
                                  ),
                                  behaviors: [
                                    charts.DatumLegend(
                                      position: charts.BehaviorPosition.bottom,
                                      horizontalFirst: true,
                                      cellPadding: EdgeInsets.only(left: width * 0.06, bottom: 2),
                                      entryTextStyle: common.TextStyleSpec(
                                        fontSize: (11).toInt(), color: charts.MaterialPalette.black,
                                      ),
                                      showMeasures: false,
                                      legendDefaultMeasure: charts.LegendDefaultMeasure.none,
                                    ),
                                  ],
                                  defaultRenderer: charts.ArcRendererConfig(
                                      arcRendererDecorators: [
                                        charts.ArcLabelDecorator(
                                          insideLabelStyleSpec: charts.TextStyleSpec(
                                            fontSize: (12).toInt(), color: charts.MaterialPalette.white,
                                          ),
                                          outsideLabelStyleSpec: charts.TextStyleSpec(
                                            fontSize: (11).toInt(), color: charts.MaterialPalette.black,
                                          ),
                                          labelPosition: charts.ArcLabelPosition.auto,
                                        )
                                      ])
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? Colors.white : Colors.grey[100],
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomText.text('Líquido nos ultimos ${kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                      && !ResponsiveBreakpoints.of(context).isPhone  ? '6' : '3'} meses', style: const TextStyle(color: Colors.black),),
                      const SizedBox(height: 10,),
                      Container(height: height * 0.25,
                        child: charts.BarChart(
                          [charts.Series<ChartColum, String>(
                            id: 'Holerites',
                            displayName: 'Líquido nos ultimos ${kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                                && !ResponsiveBreakpoints.of(context).isPhone ? '6' : '3'} meses',
                            domainFn: (ChartColum sales, _) => sales.data,
                            measureFn: (ChartColum sales, _) => sales.valor,
                            colorFn: (_, __) => colors.Color.fromHex( code: 'f0D47A1'),
                            data: HoleriteModel().toColum(holerite!.historicos!.toList(), context),
                            labelAccessorFn: (ChartColum sales, _) =>
                            'R\$${sales.valor.toInt()}',
                          ),
                          ],
                          selectionModels: [
                            charts.SelectionModelConfig<String>(
                              type: charts.SelectionModelType.info,
                              updatedListener: (v){
                                if(v.selectedDatum.length > 0){
                                  context.read<HoleriteManager>().dropdowndata = v.selectedDatum.first.datum.data;

                                }
                              }
                            )
                          ],
                          animate: true,
                          vertical: true,
                          domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(

                                // Tick and Label styling here.
                                  labelStyle: charts.TextStyleSpec(
                                      fontSize: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 12 : (width * 0.03).toInt(), // size in Pts.
                                      color: charts.MaterialPalette.black),

                                  // Change the line colors to match text color.
                                  lineStyle: const charts.LineStyleSpec(
                                      color: charts.MaterialPalette.black))),
                          defaultRenderer: common.BarRendererConfig(
                            barRendererDecorator: charts.BarLabelDecorator<String>(
                                labelPadding: (height * 0.020).toInt(),
                                labelPlacement: common.BarLabelPlacement.opposeAxisBaseline,
                                insideLabelStyleSpec: charts.TextStyleSpec(
                                  fontSize: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 12 : (width * 0.03).toInt(), color: charts.MaterialPalette.white,
                                ),
                                outsideLabelStyleSpec: charts.TextStyleSpec(
                                  fontSize: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 12 : (width * 0.03).toInt(), color: charts.MaterialPalette.black,
                                )
                            ),
                            cornerStrategy: const charts.ConstCornerStrategy(20),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              const SizedBox(height: 15,),
              CustomText.text("Disponibilizado\n${holerite?.dataCriacao ?? ''}", textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          heroTag: 'File',
          backgroundColor: Config.corPri,
          focusColor: Colors.blue,
          foregroundColor: Colors.amber,
          hoverColor: Colors.green,
          splashColor: Colors.tealAccent,
          // focusColor: Settings.corPri.withOpacity(0.5),
          onPressed: () async {
            File? a;
            Uint8List? b;
            String? html;
            try {
              carregar(context);
              b = await context.read<HoleriteManager>().holeriteresumoBytes(
                  UserHoleriteManager.sUser, widget.idComp, widget.mes, widget.ano, holerite?.holeriteTipoCod );

              /*if(kIsWeb){

              }else{
                a = await context.read<HoleriteManager>().holeriteresumo(
                    UserHoleriteManager.sUser, widget.idComp, widget.mes, widget.ano, holerite?.holeriteTipoCod );
              }*/
            } catch(e){
              debugPrint(e.toString());
            } finally {
              Navigator.pop(context);
            }
            if(b != null){
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> FileHero( 'holerite-${widget.ano}-${widget.mes}',
                    file: a, memori: b, html: html,)));
            }else{
              InfoAlertBox(
                  context: context,
                  title: 'Atenção',
                  infoMessage: 'Não foi possivel carregar o holerite\nverifique sua conexão com internet!',
                  buttonText: 'ok'
              );
            }
          },
          label: CustomText.text('Visualizar e Assinar'.toUpperCase(),
            style: const TextStyle(fontSize: 20, color: Colors.white),)

      ),
    );
  }
}
