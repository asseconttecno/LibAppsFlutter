import 'dart:io';
import '../../../common/actions/actions.dart';
import '../../../services/login/login_manager.dart';
import '../../../settintgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ScreenConfig extends StatefulWidget {
  @override
  _ScreenConfigState createState() => _ScreenConfigState();
}

class _ScreenConfigState extends State<ScreenConfig> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool color = context.watch<Settings>().darkTemas;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          alignment: Alignment.topCenter,
          padding: MediaQuery.of(context).padding,
          height: 120,
          decoration: BoxDecoration(
              color: color ?
              Theme.of(context).primaryColor : Settings.corPribar,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(45),
                bottomLeft: Radius.circular(45),
              )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(Platform.isAndroid ? Icons.arrow_back :
                      Icons.arrow_back_ios, color: Colors.white,
                    ),
                    onPressed: ()=> Navigator.pop(context)
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text('Configurações', style: TextStyle(fontSize: 18, color: Settings.corPri),),
                ),
                Theme(
                  data: Theme.of(context).copyWith(iconTheme: IconThemeData(color: Colors.white)),
                  child: actions(context)
                )
              ],
            ),
          ),
        ),
      ),
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
                        context.read<Settings>().darkTemas = valor;
                      }
                  ),
                  Divider(height: 2,),
                  Consumer<LoginManager>(
                    builder: (_, bio, __) {
                      return SwitchListTile(
                          title: Text("Login com Bio/Face"),
                          value: bio.bio,
                          onChanged: (bool valor) {
                            if(bio.checkbio){
                              bio.perguntar = true;
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
                  Text('Versao '+ Settings.versao),
                ],
              ),
            )
          ]
        )
      ),
    );
  }
}
