import 'package:assecontservices/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common;
import 'package:charts_common/src/common/color.dart' as colors;


import '../../../common/common.dart';
import '../../../config.dart';
import '../../../model/model.dart';


class GraficosHolerite extends StatefulWidget {
  String? titulo;
  double? totalVencimentos;
  double? liquido;
  double? totalDescontos;
  List<ChartColum>? listChartColum;
  Function(charts.SelectionModel<String>)? updatedChartColum;
  Function()? onPressfloatingButton;
  String? createDate;
  bool isLoad;


  GraficosHolerite(
      {this.titulo,
      this.totalVencimentos,
      this.liquido,
      this.totalDescontos,
      this.listChartColum,
      this.updatedChartColum,
      this.createDate,
      this.onPressfloatingButton,
      this.isLoad = false,
      });

  @override
  State<GraficosHolerite> createState() => _DetalhesHoleriteState();
}

class _DetalhesHoleriteState extends State<GraficosHolerite> {
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
      appBar: widget.titulo == null ? null : AppBar(
        title: Text(widget.titulo ?? ''),
      ),
      body: Container(
        decoration: widget.titulo == null ? null :  BoxDecoration(
            border: Border(bottom: BorderSide(width: 70,
                color: Theme.of(context).scaffoldBackgroundColor))
        ),
        width: width,
        height: height,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: CustomShimmerLoad(
          isLoad: widget.isLoad,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
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
                                child: CustomText.text("Proventos\n${
                                    widget.totalVencimentos.real()}",
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
                                child: CustomText.text("Descontos\n${
                                    widget.totalDescontos.real()}",
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
                                child: CustomText.text("Liquido\n${
                                    widget.liquido.real()}",
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
                          decoration: BoxDecoration(
                              color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                                  && !ResponsiveBreakpoints.of(context).isPhone
                                  ? Colors.white : Colors.grey[100],
                              borderRadius: BorderRadius.circular(15)
                          ),
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
                                    && !ResponsiveBreakpoints.of(context).isPhone
                                    ? BoxConstraints(maxWidth: width >= 852 ? 400 : 300) : null,
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
                                        getPorcentagem(widget.totalVencimentos ?? 10.0,
                                            widget.totalVencimentos != null && widget.liquido != null
                                                ? (widget.totalVencimentos ?? 0) + (widget.liquido ?? 0) :
                                            widget.totalVencimentos != null || widget.liquido != null
                                                ? (widget.totalVencimentos ?? 0) + (widget.liquido ?? 0) : 100.0),
                                      ),
                                      ChartPizza('Liquido',
                                        getPorcentagem(widget.liquido ?? 0.0,
                                            widget.totalVencimentos != null && widget.liquido != null
                                                ? (widget.totalVencimentos ?? 0) + (widget.liquido ?? 0) :
                                            widget.totalVencimentos != null || widget.liquido != null
                                                ? (widget.totalVencimentos ?? 0) + (widget.liquido ?? 0) : 100.0),)
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
                                          fontSize: (11).toInt(),
                                          color: charts.MaterialPalette.black,
                                        ),
                                        showMeasures: false,
                                        legendDefaultMeasure: charts.LegendDefaultMeasure.none,
                                      ),
                                    ],
                                    defaultRenderer: charts.ArcRendererConfig(
                                        arcRendererDecorators: [
                                          charts.ArcLabelDecorator(
                                            insideLabelStyleSpec: charts.TextStyleSpec(
                                              fontSize: (12).toInt(),
                                              color: charts.MaterialPalette.white,
                                            ),
                                            outsideLabelStyleSpec: charts.TextStyleSpec(
                                              fontSize: (11).toInt(),
                                              color: charts.MaterialPalette.black,
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
                if(widget.listChartColum != null && widget.listChartColum!.isNotEmpty) ...[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                              && !ResponsiveBreakpoints.of(context).isPhone
                              ? Colors.white : Colors.grey[100],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CustomText.text('Líquido nos ultimos ${kIsWeb
                              && !ResponsiveBreakpoints.of(context).isMobile
                              && !ResponsiveBreakpoints.of(context).isPhone
                              ? '6' : '3'} meses',
                            style: const TextStyle(color: Colors.black),),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: height * 0.25,
                            child: charts.BarChart(
                              [charts.Series<ChartColum, String>(
                                id: 'Holerites',
                                displayName: 'Líquido nos ultimos ${kIsWeb
                                    && !ResponsiveBreakpoints.of(context).isMobile
                                    && !ResponsiveBreakpoints.of(context).isPhone ? '6' : '3'} meses',
                                domainFn: (ChartColum sales, _) => sales.data,
                                measureFn: (ChartColum sales, _) => sales.valor,
                                colorFn: (_, __) => colors.Color.fromHex( code: 'f0D47A1'),
                                data: widget.listChartColum!,
                                labelAccessorFn: (ChartColum sales, _) =>
                                'R\$${sales.valor.toInt()}',
                              ),
                              ],
                              selectionModels: [
                                charts.SelectionModelConfig<String>(
                                    type: charts.SelectionModelType.info,
                                    updatedListener: widget.updatedChartColum
                                )
                              ],
                              animate: true,
                              vertical: true,
                              domainAxis: charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                      labelStyle: charts.TextStyleSpec(
                                          fontSize: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                                              && !ResponsiveBreakpoints.of(context).isPhone
                                              ? 12 : (width * 0.03).toInt(), // size in Pts.
                                          color: charts.MaterialPalette.black),

                                      // Change the line colors to match text color.
                                      lineStyle: const charts.LineStyleSpec(
                                          color: charts.MaterialPalette.black))),
                              defaultRenderer: common.BarRendererConfig(
                                barRendererDecorator: charts.BarLabelDecorator<String>(
                                    labelPadding: (height * 0.020).toInt(),
                                    labelPlacement: common.BarLabelPlacement.opposeAxisBaseline,
                                    insideLabelStyleSpec: charts.TextStyleSpec(
                                      fontSize: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                                          && !ResponsiveBreakpoints.of(context).isPhone
                                          ? 12 : (width * 0.03).toInt(),
                                      color: charts.MaterialPalette.white,
                                    ),
                                    outsideLabelStyleSpec: charts.TextStyleSpec(
                                      fontSize: kIsWeb && !ResponsiveBreakpoints.of(context).isMobile
                                          && !ResponsiveBreakpoints.of(context).isPhone
                                          ? 12 : (width * 0.03).toInt(),
                                      color: charts.MaterialPalette.black,
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
                ],

                if(widget.createDate != null)
                  CustomText.text("Disponibilizado\n${widget.createDate ?? ''}",
                    textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.onPressfloatingButton == null ? null
        : FloatingActionButton.extended(
          heroTag: 'File',
          backgroundColor: Config.corPri,
          focusColor: Colors.blue,
          foregroundColor: Colors.amber,
          hoverColor: Colors.green,
          splashColor: Colors.tealAccent,
          // focusColor: Settings.corPri.withOpacity(0.5),
          onPressed: widget.onPressfloatingButton,
          label: CustomText.text('Visualizar e Assinar'.toUpperCase(),
            style: const TextStyle(fontSize: 20, color: Colors.white),)
      ),
    );
  }
}
