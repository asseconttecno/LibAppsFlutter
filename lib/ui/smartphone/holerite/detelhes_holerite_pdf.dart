import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common;
import 'package:charts_common/src/common/color.dart' as colors;


import '../../../config.dart';
import '../../../controllers/controllers.dart';
import '../../../model/model.dart';
import 'detelhes_holerite.dart';


class DetalhesHoleritePDF extends StatefulWidget {
  BoxConstraints constraints;
  DetalhesHoleritePDF(this.constraints);

  @override
  _DetalhesHoleriteState createState() => _DetalhesHoleriteState();
}

class _DetalhesHoleriteState extends State<DetalhesHoleritePDF> {
  bool load = false;
  CompetenciasModel? _comp;
  HoleriteModel? _holerite;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - (WidgetsBinding.instance?.window.padding.top ?? 0);
    double width = MediaQuery.of(context).size.width;


    return Consumer2<UserHoleriteManager,HoleriteManager>(
        builder: (_, use, holerite, __){
          Future<List<HoleriteModel>?> dadosHolerite() async {
            List<HoleriteModel>? _holerite;
            try{
              if(holerite.listcompetencias.isEmpty){
                holerite.listcompetencias = await holerite.competencias(use.user, );
              }
              if(holerite.listcompetencias.isNotEmpty){
                _comp = holerite.listcompetencias.firstWhere(
                        (e) => e.descricao == holerite.dropdowndata);
                if(_comp != null){
                  _holerite = await holerite.resumoscreen(use.user, _comp!.mes!, _comp!.ano!);
                }
              }
            } catch(e){
              _holerite = null;
            }
            return _holerite;
          }

          return Scaffold(
            body: Container(
              constraints: widget.constraints,
              height: widget.constraints.maxHeight,
              width: width,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: FutureBuilder<List<HoleriteModel>?>(
                  future: dadosHolerite(),
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
                                dadosHolerite();
                              }
                          );
                        }else {
                          if(snapshot.data != null){
                            resultado =  Center(
                              child: DetalhesHolerite(
                                  snapshot.data!.reversed.toList(), _comp!.mes!, _comp!.ano!
                              ),
                            );
                          }else{
                            resultado = Center(child: Text(''));
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
