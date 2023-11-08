import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import 'detelhes_comprovantes.dart';


class ComprovantesScreen extends StatefulWidget {

  @override
  _ComprovantesScreenState createState() => _ComprovantesScreenState();
}

class _ComprovantesScreenState extends State<ComprovantesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  Apontamento? _apontamento;

  @override
  void initState() {
    _apontamento = context.read<ApontamentoManager>().apontamento.first  ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ApontamentoManager>(
        builder: (_, aponta, __){

          return CustomScaffold.custom(
            context: context,
            key: _scaffoldKey,
            height: 70,
            appTitle: 'Meus Comprovantes\nApp/Asseface',
            appbar: Center(
              child: Container(
                height: 40,
                constraints: BoxConstraints(maxWidth: 400),
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 5),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey, width: 1)
                ),
                child: DropdownButton<Apontamento>(
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  value: _apontamento ?? aponta.apontamento.first,
                  iconSize: 20,
                  elevation: 0,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                  style: TextStyle(color: Colors.black),
                  underline: Container(),
                  onChanged: ( newValue) {
                    setState(() {
                      _apontamento = newValue;
                    });
                  },
                  items: aponta.apontamento.
                  map<DropdownMenuItem<Apontamento>>(( value) {
                    return DropdownMenuItem<Apontamento>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CustomText.text(value.descricao ?? ''),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText.text(
                      kIsWeb && !ResponsiveBreakpoints.of(context).isMobile  && !ResponsiveBreakpoints.of(context).isPhone ? 'Esses comprovantes são apenas das marcações realizadasno aplicativo ou equipamento Asseponto facil (Relogio de ponto da Assecont)'
                          : 'Esses comprovantes são apenas das marcações\nrealizadasno aplicativo ou equipamento\nAsseponto facil (Relogio de ponto da Assecont)',
                    textAlign: TextAlign.center
                  ),
                ),
                Expanded(
                    child: !connectionStatus.hasConnection ?
                    Center(child: CustomText.text('Verifique sua Conexão com Internet')) :
                    aponta.apontamento.isEmpty ?
                    Center(
                      child: CustomText.text('Não possui comprovantes de marcações do App/AsseFace neste dia',
                        style: TextStyle(fontSize: 20),),
                    ) :  _apontamento == null ?
                    Center(
                      child: CustomText.text('Seleciona um periodo',
                        style: TextStyle(fontSize: 20),),
                    ) : Center(
                        child: DetalhesComprovantes(_apontamento!)
                    )
                ),
              ],
            ),
          );
        }
    );
  }
}