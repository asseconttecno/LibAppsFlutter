
import 'package:flutter/material.dart';

import '../config.dart';
import '../controllers/controllers.dart';
import '../enums/enums.dart';
import 'common.dart';

BiometriaAlert(BuildContext context)  {
  if(Config.bioState == BioSupportState.supported && context.read<BiometriaManager>().checkbio){
    return CustomAlert.custom(
      context: context,
      widgeTitulo: Icon(Icons.fingerprint, size: 100, color: Colors.blueAccent,),
      corpo: Consumer<BiometriaManager>(
        builder: (_,bio,__){
          return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Gostaria de se logar com sua biometria?",
                    style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(focusColor: Colors.blue,
                        value: bio.perguntar,
                        onChanged: ( valor){
                          bio.perguntar = valor!;
                        }
                    ),
                    Text("Nao Perguntar novamente", textAlign: TextAlign.left,
                      style: TextStyle( fontSize: 14),
                    ),
                  ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          bio.bio = false;
                          Navigator.pop(context);
                        },
                        child: Text("Não")
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                        onPressed: () {
                          bio.bio = true;
                          Navigator.pop(context);
                        },
                        child: Text("Sim")
                    ),
                  ],
                )
              ]);
        },
      ),
    );
  }
}