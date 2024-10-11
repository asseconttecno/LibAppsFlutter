import 'package:flutter/services.dart';



/// Formata o valor do campo com a mascara kg,g (ex: `103,8`)
class NumInputFormatter extends TextInputFormatter {
  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.deny(
      RegExp(r'[^0-9,]|(?<=,)[^0-9]')
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo


    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();



    if (newValue.text.length >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
