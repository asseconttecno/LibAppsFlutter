import '../../../common/actions/actions.dart';
import '../../../helper/conn.dart';
import '../../../model/holerite/model_holerite.dart';
import '../../../services/holerite/holerite_manager.dart';
import '../../../settintgs.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'detelhes_holerite.dart';

class HoleriteScreen extends StatefulWidget {

  @override
  _HoleriteScreenState createState() => _HoleriteScreenState();
}

class _HoleriteScreenState extends State<HoleriteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CompetenciasModel? _comp;
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  @override
  void initState() {
    context.read<HoleriteManager>().competencias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Consumer<HoleriteManager>(
        builder: (_, holerite, __){
          Future<List<HoleriteModel>?> dadosHolerite() async {
            List<HoleriteModel>? _holerite;
            try{
              if((holerite.listcompetencias.length) == 0){
                holerite.listcompetencias = await holerite.competencias();
              }
              if((holerite.listcompetencias.length) > 0){
                _comp = holerite.listcompetencias.firstWhere(
                        (e) => e.descricao == holerite.dropdowndata);
                if(_comp != null){
                  _holerite = await holerite.resumoscreen(_comp!.mes!, _comp!.ano!);
                }
              }
            } catch(e){
              _holerite = null;
            }
            return _holerite;
          }


          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Holerites'),
                centerTitle: true,
                actions: [
                  actions(context),
                ],
              ),
              body: Container(
                child: Column(
                  children: [
                    Container(
                      height: 80, width: width,
                      decoration: BoxDecoration(
                          color: context.watch<Settings>().darkTemas ?
                          Theme.of(context).primaryColor : Settings.corPribar,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(45),
                            bottomLeft: Radius.circular(45),
                          )
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey, width: 1)
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              value: holerite.dropdowndata,
                              iconSize: 20,
                              elevation: 0,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                              style: TextStyle(color: Colors.black),
                              underline: Container(),
                              onChanged: ( newValue) {
                                holerite.dropdowndata = newValue!;
                                dadosHolerite();
                              },
                              items: holerite.listcompetencias.map((e) => e.descricao).
                                toList().map<DropdownMenuItem<String>>(( value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Text(value ?? ''),
                                    ),
                                  );
                              }).toList(),
                            ),
                          ),
                        ],
                      )
                    ),
                    Expanded(
                      child: !connectionStatus.hasConnection ?
                      Center(child: Text('Verifique sua Conexão com Internet')) :
                      holerite.dropdowndata == 'Holerites' ?
                        Center(
                          child: Text('Usuário não tem Holerites',
                            style: TextStyle(fontSize: 20),),
                        ) : FutureBuilder<List<HoleriteModel>?>(
                          future: dadosHolerite(),
                          builder: (context, snapshot){
                            Widget resultado;
                            switch( snapshot.connectionState ){
                              case ConnectionState.none :
                              case ConnectionState.waiting :
                                resultado = Center(child: CircularProgressIndicator());
                                break;
                              case ConnectionState.active :
                              case ConnectionState.done :
                                if( snapshot.hasError || !snapshot.hasData || snapshot.data == null){
                                  resultado = GestureDetector(
                                      child: Icon(Icons.autorenew_outlined,
                                        color: Settings.corPri, size: 70,),
                                      onTap: (){
                                        dadosHolerite();
                                      }
                                  );
                                }else {
                                  resultado = Center(
                                      child: DetalhesHolerite(
                                          snapshot.data!.reversed.toList(), _comp!.mes!, _comp!.ano!
                                      )
                                  );
                                }
                                break;
                            }
                            return resultado;
                          },
                      )
                    ),
                  ],
                ),
              )
          );
        }
    );
  }
}