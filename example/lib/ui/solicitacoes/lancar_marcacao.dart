import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:assecontservices/assecontservices.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class LancarMarcacao extends StatefulWidget {

  @override
  _LancarMarcacaoState createState() => _LancarMarcacaoState();
}

class _LancarMarcacaoState extends State<LancarMarcacao> {
  List<String> marcacoes = ['','','',''];

  setmarcacao(String titulo, int indice, String string){
    TextEditingController controler_hora =  TextEditingController(text: string);
    return Container(height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 1, child: Text(titulo)),
          Expanded(flex: 2,
            child: DateTimeField(
              format: DateFormat('HH:mm'),
              keyboardType: TextInputType.datetime,
              controller: controler_hora,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.timer,),),
              onShowPicker: (context, currentValue) async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.convert(time);
              },
              onChanged: (v){
                if(v != null){
                  setState(() {
                    marcacoes[indice] = DateFormat("HH:mm").format(v);
                  });
                }else{
                  setState(() {
                    marcacoes[indice] = '';
                  });
                }
                debugPrint(marcacoes.toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    context.read<MemorandosManager>().updateObs(true);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<MemorandosManager>(
      builder: (_, memo, __) {
        return Container(//height: 310, width: 300,
          child: Column(mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(left: 15, right: 15, bottom: 3),
                child: DateTimeField(
                  format: DateFormat('dd/MM/yyyy'),
                  keyboardType: TextInputType.datetime,
                  controller: memo.controlerData,
                  decoration: const InputDecoration(
                    labelText: "Data:",
                    prefixIcon: Icon(Icons.today,),
                  ),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100)
                    );
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Column(
                children: [
                  setmarcacao('Entrada:', 0, marcacoes[0]),
                  setmarcacao('Intervalo:', 1, marcacoes[1]),
                  setmarcacao('Intervalo:', 2, marcacoes[2]),
                  setmarcacao('Saida:', 3, marcacoes[3]),
                ],
              ),
              const SizedBox(height: 10,),
              Padding(padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(padding: const EdgeInsets.all(5),
                  child: TextField(maxLength: 255, maxLines: 2, readOnly: false,
                    decoration: const InputDecoration(labelText: "OBS:",
                      border: OutlineInputBorder(borderSide: BorderSide(width: 5 ,color: Colors.blue)),
                      prefixIcon: Icon(Icons.edit,),
                    ),
                    controller: memo.controlerObs,
                  ),
                ),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: TextButton(
                      child: const Padding(
                        padding: EdgeInsets.only(top: 12,),
                        child: Text("Cancelar", style: TextStyle(fontSize: 14),),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    child: TextButton(
                      child: const Padding(
                        padding: EdgeInsets.only(top: 12,),
                        child: Text("Ok",style: TextStyle(fontSize: 14),),
                      ),
                      onPressed: () async {
                        if(memo.controlerData.text != null && (marcacoes[0] != ''
                            || marcacoes[1] != '' || marcacoes[2] != '' || marcacoes[3] != '')){
                          List _i = memo.controlerData.text.split("/");
                          DateTime datahora = DateTime(int.parse(_i[2]), int.parse(_i[1]), int.parse(_i[0]));
                          Navigator.pop(context);
                          await context.read<MemorandosManager>().postMemorando(
                            context, context.read<UserPontoManager>().usuario!,
                            datahora, memo.controlerObs.text, 5, marcacao: marcacoes,
                          );

                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5,),
            ],
          ),);
      },
    );
  }
}
