
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import '../../../common/common.dart';
import '../../../config.dart';
import '../../../helper/helper.dart';
import '../../../model/model.dart';
import '../../../controllers/controllers.dart';
import '../../ui.dart';
import 'detelhes_holerite.dart';

class HoleriteScreen extends StatefulWidget {

  @override
  _HoleriteScreenState createState() => _HoleriteScreenState();
}

class _HoleriteScreenState extends State<HoleriteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CompetenciasModel? _comp;
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();



  @override
  void initState() {
    context.read<HoleriteManager>().competencias(UserHoleriteManager.user);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;

    return Consumer2<UserHoleriteManager,HoleriteManager>(
        builder: (_, use, holerite, __){
          Future<List<HoleriteModel>?> dadosHolerite() async {
            List<HoleriteModel>? _holerite;
            try{
              if(holerite.listcompetencias.isEmpty){
                holerite.listcompetencias = await holerite.competencias(UserHoleriteManager.user);
              }
              if(holerite.listcompetencias.isNotEmpty){
                _comp = holerite.listcompetencias.firstWhere(
                        (e) => e.descricao == holerite.dropdowndata);
                if(_comp != null){
                  _holerite = await holerite.resumoscreen(UserHoleriteManager.user, _comp!.mes!, _comp!.ano!);
                }
              }
            } catch(e){
              _holerite = null;
            }
            return _holerite;
          }

          return CustomScaffold.custom(
              key: _scaffoldKey,
              context: context,
              height: 70,
              appTitle: 'Meu Holerite',
              appbar: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black,),
                      style: const TextStyle(color: Colors.black),
                      underline: Container(),
                      onChanged: ( newValue) {
                        holerite.dropdowndata = newValue!;
                        dadosHolerite();
                      },
                      items: holerite.listcompetencias.map((e) => e.descricao).
                      toList().map<DropdownMenuItem<String>>(( value) {
                        return DropdownMenuItem<String>(
                          value: value ?? '',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: CustomText.text(value ?? ''),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              body: Container(
                  //height: MediaQuery.of(context).size.height - 100 - AppBar().preferredSize.height  -MediaQuery.of(context).padding.top,
                  child: !connectionStatus.hasConnection ?
                  Center(child: CustomText.text('Verifique sua Conexão com Internet')) :
                  holerite.dropdowndata == 'Holerites' ?
                  Center(
                    child: CustomText.text('Usuário não tem Holerites',
                      style: TextStyle(fontSize: 20),),
                  ) : FutureBuilder<List<HoleriteModel>?>(
                    future: dadosHolerite(),
                    builder: (context, snapshot){
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
                                child: Icon(Icons.autorenew_outlined,
                                  color: Config.corPri, size: 70,),
                                onTap: (){
                                  dadosHolerite();
                                }
                            );
                          }else {
                            if(snapshot.data?.isNotEmpty ?? false){
                              resultado = Center(
                                  child: DetalhesHolerite(
                                      snapshot.data!.reversed.toList(), _comp!.mes!, _comp!.ano!
                                  )
                              );
                            }else{
                              resultado = Center(child: CustomText.text('Nenhum Holerite disponivel'));
                            }
                          }
                          break;
                      }
                      return resultado;
                    },
                  )
              )
          );
        }
    );
  }
}