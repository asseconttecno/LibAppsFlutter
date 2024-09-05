import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import '../../../common/common.dart';
import '../../../enums/versao_app.dart';
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

    return HomeIoWidget(
        height: 30, conf: true,
        appTitle: 'Configurações',
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SwitchListTile(
                        title: CustomText.text("Modo Escuro"),
                        value: color,
                        onChanged: (bool valor){
                          context.read<Config>().darkTemas = valor;
                        }
                    ),
                    if(!kIsWeb)
                    const Divider(height: 2,),
                    if(!kIsWeb)
                    Consumer<BiometriaManager>(
                      builder: (_, bio, __) {
                        return SwitchListTile(
                            title: CustomText.text("Login com Bio/Face"),
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
                    const Divider(height: 2,),
                  ],
                ),
              ),

              Column(
                children: [
                  if(Config.conf.nomeApp == VersaoApp.HoleriteApp)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: const BorderRadius.all(Radius.circular(8))
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Deletar sua conta!",
                              style: TextStyle(color: Colors.redAccent)),
                          const Text("Esta ação excluirá permanentemente sua conta e não poderá ser desfeita.",
                              style: TextStyle(color: Colors.redAccent)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
                            ),
                            onPressed: () async {
                              _showDeleteDialog(context);
                            },
                            child: const Center(child: Text("Excluir",
                              style: TextStyle(color: Colors.white),),),
                          ),
                        ],
                      ),
                    ),
                  if(Config.conf.nomeApp == VersaoApp.HoleriteApp)
                    const SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, right: 25),
                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText.text('Versao '+ Config.versao),
                      ],
                    ),
                  )
                ],
              )
            ]
        )
    );
  }


  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Deletar sua conta!",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Depois de excluir esta conta, não há como voltar atrás.",),
                SizedBox(height: 25),
                Text("Deseja excluir sua conta?",),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 15),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar", ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                "Confirmar",
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                await context.read<UserHoleriteManager>().deleteUser().then((value) {
                  if(value){
                    Navigator.of(context).pushReplacementNamed('/');
                  }else{
                    CustomSnackbar.context(context, 'Não foi possivel excluir sua conta, tente novamente!', Colors.red);
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}
