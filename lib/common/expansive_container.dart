
import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';

import 'common.dart';



class ExpansiveContainer extends StatefulWidget {

  Widget? child;
  Widget? tituloWidget;
  String titulo;
  Color? tituloColor;
  Color? color;
  bool isExpanded;

  ExpansiveContainer({this.child, this.titulo = '', this.tituloWidget, this.isExpanded = false, this.color , this.tituloColor});

  @override
  State<ExpansiveContainer> createState() => _ExpansiveContainerState();
}

class _ExpansiveContainerState extends State<ExpansiveContainer> {
  bool open = false;


  @override
  void initState() {
    open = widget.isExpanded;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: widget.color ?? (context.watch<Config>().darkTemas ? Theme.of(context).primaryColor : Colors.white),
      center: true,
      ispadding: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  open = !open;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: widget.tituloWidget ?? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText.text(widget.titulo,
                            style: TextStyle(fontSize: 18, color: widget.tituloColor ?? (context.watch<Config>().darkTemas ? Colors.white : Colors.black))
                        ),
                      ),
                    ),
                    Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 34, color: context.read<Config>().darkTemas ? Config.corPri : Colors.blue,)
                  ]
                ),
              ),
            ),
            if(open)
              Container(
                width: MediaQuery.of(context).size.width,
                child: widget.child,
              )
          ],
        )
      ),
    );
  }
}