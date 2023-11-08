import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import 'detelhes_espelho.dart';


class EspelhoScreen extends StatefulWidget {

  @override
  _EspelhoScreenState createState() => _EspelhoScreenState();
}

class _EspelhoScreenState extends State<EspelhoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  @override
  void initState() {
    List<Apontamento> aponta = context.read<ApontamentoManager>().apontamento;
    if(aponta.length > 0)context.read<EspelhoManager>().setMesAtual(aponta.first);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;

    return Consumer2<EspelhoManager, ApontamentoManager>(
        builder: (_, espelho, aponta, __){
          return CustomScaffold.custom(
              context: context,
              height: 70,
              key: _scaffoldKey,
              appTitle: 'Meu Espelhos',
              expanAppbar: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      constraints: BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 1)
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        value: espelho.dropdowndata,
                        iconSize: 20,
                        elevation: 0,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black,),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(),
                        onChanged: ( newValue) {
                          espelho.dropdowndata = newValue!;
                          espelho.apontamento = aponta.apontamento.firstWhere((e) => e.descricao == newValue);
                        },
                        items: aponta.apontamento.map((e) => e.descricao).
                        toList().map<DropdownMenuItem<String>>(( value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: CustomText.text(value ?? ''),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
                  child: !connectionStatus.hasConnection ?
                    Center(child: CustomText.text('Verifique sua Conexão com Internet')) :
                  espelho.apontamento == null ?
                    Center(
                    child: CustomText.text('Usuario nao possui periodo de apontamento',
                      style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                  ) : Center(child: DetalhesEspelho(espelho.apontamento!))
              ),
          );
        }
    );
  }
}