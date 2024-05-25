import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'package:responsive_framework/responsive_framework.dart';


class FilterWidget<T extends Object?> extends StatelessWidget {
  const FilterWidget({super.key, required this.onFiltro, this.padding, this.filtro = 3});

  final Function(int) onFiltro;
  final EdgeInsets? padding;
  final int filtro;
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(child: Container(),),

          Text(filtro == 0 ? 'Todos'
              : filtro == 3 ? 'Ultimos 3'
              : filtro == 6 ? 'Ultimos 6'
              : 'Ultimos 12', style: TextStyle(fontSize: 16),),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<int>(
                  surfaceTintColor: Colors.white,
                  itemBuilder: (context) =>  [
                    popupMenuEntry(3,"Ultimos 3", filtro == 3),
                    popupMenuEntry(6,"Ultimos 6", filtro == 6),
                    popupMenuEntry(12,"Ultimos 12", filtro == 12),
                    popupMenuEntry(0,"Todos", filtro == 0),
                  ],
                  initialValue: filtro,
                  offset: const Offset(10,5),
                  onSelected: (value) async {
                    await onFiltro(value);
                  },
                  child: const Icon(Icons.filter_list_rounded,),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }


  PopupMenuEntry<int> popupMenuEntry(int value, String text, bool selected){
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.circle_outlined, color: Colors.blue, size: 25,),
              if(selected)
                const Icon(Icons.circle, color: Colors.blue, size: 10)
            ],
          ),
          const SizedBox(width: 5,),
          Text(text),
        ],
      ),
    );
  }
}


