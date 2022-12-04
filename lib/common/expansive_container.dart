
import 'package:flutter/material.dart';

import 'common.dart';



class ExpansiveContainer extends StatefulWidget {
  Widget? child;
  Widget? tituloWidget;
  String titulo;
  Color tituloColor;
  Color color;

  ExpansiveContainer({this.child, this.titulo = '', this.tituloWidget,
    this.color = Colors.white, this.tituloColor = Colors.black});

  @override
  State<ExpansiveContainer> createState() => _ExpansiveContainerState();
}

class _ExpansiveContainerState extends State<ExpansiveContainer> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: widget.color,
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
                            style: TextStyle(fontSize: 18, color: widget.tituloColor)
                        ),
                      ),
                    ),
                    Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 34, color: Colors.blue,)
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