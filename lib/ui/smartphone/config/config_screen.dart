import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import '../../../ui/ui.dart';
import '../../../controllers/controllers.dart';
import '../../../../config.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ScreenConfigState createState() => _ScreenConfigState();
}

class _ScreenConfigState extends State<ConfigScreen> {

  @override
  Widget build(BuildContext context) {
    bool color = context.watch<Config>().darkTemas;

    return CustomScaffold.custom(
        context: context,
        height: 100,
        appTitle: 'Configurações',
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SwitchListTile(
                            title: Text("Modo Escuro"),
                            value: color,
                            onChanged: (bool valor){
                              context.read<Config>().darkTemas = valor;
                            }
                        ),
                        Divider(height: 2,),
                        Consumer<BiometriaManager>(
                          builder: (_, bio, __) {
                            return SwitchListTile(
                                title: Text("Login com Bio/Face"),
                                value: bio.bio,
                                onChanged: (bool valor) {
                                  if(bio.checkbio){
                                    bio.perguntar = !valor;
                                    bio.bio = valor;
                                  }
                                }
                            );
                          },
                        ),
                        Divider(height: 2,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, right: 25),
                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Versao '+ Config.versao),
                      ],
                    ),
                  )
                ]
            )
        )
    );
  }
}
