import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../../controllers/controllers.dart';
import 'item_listwheel.dart';

PeriodoApontamento(BuildContext context){

  Widget child = Consumer<ApontamentoManager>(
      builder: (_,aponta,__){
        return Container(
            //height: 400,
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar')
                      ),
                      TextButton(
                          onPressed: (){
                            if(aponta.indice > 0){
                              context.read<UserPontoManager>().updateUser(aponta: aponta.apontamento[aponta.indice]);
                              context.read<HomePontoManager>().homeUpdate();
                              context.read<MarcacoesManager>().getEspelho(context.read<UserPontoManager>().usuario);
                              context.read<MemorandosManager>().memorandosUpdate();
                              context.read<BancoHorasManager>().getFuncionarioHistorico(context.read<UserPontoManager>().usuario);
                              Navigator.pop(context);
                            }else{
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Ok')
                      ),
                    ],
                  ),
                ),
                Text('APONTAMENTOS', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.normal,
                  color: context.watch<Config>().darkTemas ? Colors.white : Colors.black,
                  decoration: TextDecoration.none
                ),),
                SizedBox(height: 20,),
                Container(
                  height: 200,
                  child: ListWheelScrollView(
                      itemExtent: 70,
                      onSelectedItemChanged:(value){
                        aponta.indice = value;
                      },
                      children: aponta.apontamento.map(
                              (e) => ItemListWheel(context, e,
                                  aponta.indice == aponta.apontamento.indexOf(e)
                              )).toList()
                  ),
                )
              ],
            )
        );
      }
  );

  return showModalBottomSheet(
      context: context,
      builder: (context) => child
  );
}

/*
LiveList(
              showItemInterval: Duration(milliseconds: 0),
              showItemDuration: Duration(milliseconds: 180),
              itemCount: aponta?.apontamento?.length ?? 0,
              itemBuilder: (BuildContext context, int indice, Animation<double> animation){

                return FadeTransition(
                  opacity: Tween<double>(
                    begin: 0, end: 1,
                  ).animate(animation),
                  child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, -0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: InkWell(
                          onTap: (){
                            context.read<UserManager>().updateAponta(aponta?.apontamento[indice]);
                            context.read<HomeManager>().getHome();
                            context.read<MarcacaoManager>().getEspelho();
                            context.read<MemorandosManager>().getMemorandos();
                            context.read<BancoManager>().getFuncionarioHistorico();
                            Navigator.pop(context);
                          },
                          child: Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              child: Container(height: 70, alignment: Alignment.center,
                                child: Text( aponta?.apontamento[indice].descricao.toUpperCase() ?? "",
                                  style: TextStyle(fontSize: 20,),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              )
                          )
                      )
                  ),
                );
              },
            ),
 */