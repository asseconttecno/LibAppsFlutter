import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  Widget icon;
  String titulo;
  String valor;
  VoidCallback? function;

  CustomListTile(this.icon, this.titulo, this.valor, this.function);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.025, vertical: 2),
      child: Card(
        child: InkWell(
          onTap: function,
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      icon == null
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: icon,
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
                    ],
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
                        fontSize: icon == null ? 14 : 18,
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
