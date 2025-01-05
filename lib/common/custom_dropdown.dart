
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';


class CustomDropDown<T extends Object?> extends StatelessWidget {
  const CustomDropDown({super.key, required this.onChanged, this.value,
    this.items, this.width, this.suffix,
    this.height, this.textAlign = false, this.isBorder = true,  this.title, this.txtColor = Colors.black,
    this.fillColor = Colors.white, required this.onText, this.hintText});
  final void Function(T) onChanged;
  final String Function(T) onText;
  final List<T>? items;
  final T? value;
  final double? width;
  final double? height;
  final bool textAlign;
  final bool isBorder;
  final String? title;
  final Color txtColor;
  final Widget? suffix;
  final Color? fillColor;
  final String? hintText;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: textAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
              child: Text(title!,
                style: TextStyle(
                  color: context.watch<Config>().darkTemas
                      ? txtColor == Colors.black
                      ? Colors.white
                      : txtColor
                      : txtColor == Colors.white
                      ? Colors.black
                      : txtColor,
                  fontSize: textAlign ? 18 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          SizedBox(
            height: height, width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: DropdownButtonFormField<T>(
                    isExpanded: true,
                    value: value,
                    elevation: 0,
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                    iconEnabledColor: const Color(0xffB0B0B0),
                    padding: EdgeInsets.zero,
                    iconDisabledColor: const Color(0xffB0B0B0),
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: hintText ?? "Selecione",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                      contentPadding: const EdgeInsets.only(left: 15),
                      fillColor: fillColor ?? Colors.white,
                      iconColor: const Color(0xffB0B0B0),
                      filled: fillColor != null,
                      enabledBorder: isBorder ? const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffB0B0B0)),
                        borderRadius: BorderRadius.all(Radius.circular(10)), // Adjust radius as needed
                      ) : InputBorder.none,
                      border: isBorder ? const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffB0B0B0)),
                        borderRadius: BorderRadius.all(Radius.circular(10)), // Adjust radius as needed
                      ) : InputBorder.none
                    ),
                    //itemHeight: height,
                    onChanged: (v){
                      if(v != null){
                        onChanged(v);
                      }
                    },
                    items: items?.map((e) => DropdownMenuItem<T>(
                      value: e,
                      child: Text(onText(e)),
                    )).toList() ?? [],
                  ),
                ),
                if(suffix != null)
                  suffix!
              ],
            ),
          ),
        ],
      ),
    );
  }
}
