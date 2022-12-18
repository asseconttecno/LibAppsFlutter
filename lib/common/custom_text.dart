

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomText {
  
  static Widget text(String? txt, {
    Key? key,
    TextStyle style = const TextStyle(fontSize: 13),
    TextAlign? textAlign,
    bool? softWrap = false,
    bool autoSize = false,
    TextOverflow? overflow,
    int? maxLines}){

    if(autoSize) {
      return AutoSizeText(txt ?? '', maxLines: maxLines, textAlign: textAlign,
        maxFontSize: (style.fontSize ?? 13), minFontSize: (style.fontSize ?? 13) - 1,
        wrapWords: false, softWrap: softWrap, overflow: overflow, textScaleFactor: 1.0,
        style: style.copyWith(fontSize: style.fontSize ?? 13),
      );
    }

    return Text(txt ?? '',
      key: key,
      textScaleFactor: 1.0,
      maxLines: maxLines,
      overflow:overflow,
      softWrap:softWrap,
      textAlign:textAlign,
      style: style.copyWith(fontSize: style.fontSize ?? 13),
    );
  }
}