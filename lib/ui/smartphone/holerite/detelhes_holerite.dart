import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:universal_io/io.dart';

import '../../../common/heros_file.dart';
import '../../../common/load_screen.dart';
import '../../../controllers/controllers.dart';
import '../../../model/model.dart';
import 'graficos_holerite.dart';


class DetalhesHolerite extends StatefulWidget {
  DatumHolerite holerite;
  DetalhesHolerite(this.holerite);

  @override
  State<DetalhesHolerite> createState() => _DetalhesHoleriteState();
}

class _DetalhesHoleriteState extends State<DetalhesHolerite> {
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

    return GraficosHolerite(
      titulo: '${widget.holerite.attributes?.type ?? ''} ${widget.holerite.attributes?.competence ?? ''}',
      totalVencimentos: widget.holerite.attributes?.data?.funcionarioResumo!.totalVencimentos,
      totalDescontos: widget.holerite.attributes?.data?.funcionarioResumo?.totalDescontos,
      liquido: widget.holerite.attributes?.data?.funcionarioResumo?.liquido,
      listChartColum: context.read<HoleriteManager>().filtroHolerite(widget.holerite, kIsWeb
          && !ResponsiveBreakpoints.of(context).isMobile
          && !ResponsiveBreakpoints.of(context).isPhone
          ? 6 : 3),
      updatedChartColum: (v){
        if(v.selectedDatum.isNotEmpty){
          setState(() {
            widget.holerite = context.read<HoleriteManager>()
                .selectHolerite(v.selectedDatum.first.datum.ind);
          });
        }
      },
      onPressfloatingButton: () async {
        File? a;
        Uint8List? b;
        String? html;
        try {
          carregar(context);
          //b = await context.read<HoleriteManager>().holeriteresumoBytes(
          //    UserHoleriteManager.user, idComp, mes, ano, holerite?.holeriteTipoCod );

          /*if(kIsWeb){

              }else{
                a = await context.read<HoleriteManager>().holeriteresumo(
                    UserHoleriteManager.sUser, idComp, mes, ano, holerite?.holeriteTipoCod );
              }*/
        } catch(e){
          debugPrint(e.toString());
        } finally {
          Navigator.pop(context);
        }
        if(b != null){
          await Navigator.push(context, MaterialPageRoute(
              builder: (context)=> FileHero('holerite-${widget.holerite.attributes?.year}-${widget.holerite.attributes?.month}',
                file: a, memori: b, html: html,)));
        }else{
          InfoAlertBox(
              context: context,
              title: 'Atenção',
              infoMessage: 'Não foi possivel carregar o holerite\nverifique sua conexão com internet!',
              buttonText: 'ok'
          );
        }
      }
    );
  }
}
