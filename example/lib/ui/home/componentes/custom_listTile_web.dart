import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTileWeb extends StatelessWidget {
  Widget? icon;
  String titulo;
  String valor;
  VoidCallback? function;

  CustomListTileWeb(this.icon, this.titulo, this.valor, this.function);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.025, vertical: 2),
      child: Card(
        child: InkWell(
          onTap: function,
          child: Container(
            height: 200, width: 200,
            padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: icon == null
                      ? Container()
                      : icon!,
                ),
                Expanded(
                  child: CustomText.text(
                    titulo,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: icon == null ? 12 : 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomText.text(
                      valor,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: icon == null ? 18 : 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
