import 'package:brasil_fields/src/formatters/cnpj_input_formatter.dart';
import 'package:brasil_fields/src/formatters/compound_formatters/compound_formatter.dart';
import 'package:brasil_fields/src/formatters/cpf_input_formatter.dart';
import 'package:brasil_fields/src/interfaces/compoundable_formatter.dart';
import 'package:flutter/services.dart';

class CpfOrRGFormatter extends CompoundFormatter {
  CpfOrRGFormatter() : super([RGInputFormatter(), CpfInputFormatter()]);
}


class RGInputFormatter extends TextInputFormatter implements CompoundableFormatter {
  // Define o tamanho máximo do campo.
  @override
  int get maxLength => 9;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    if (newValueLength > maxLength) {
      return oldValue;
    }

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    if (newValueLength >= 3) {
      newText.write('${newValue.text.substring(0, substrIndex = 2)}.');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newValueLength >= 6) {
      newText.write('${newValue.text.substring(2, substrIndex = 5)}.');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newValueLength >= 9) {
      newText.write('${newValue.text.substring(5, substrIndex = 8)}-');
      if (newValue.selection.end >= 8) selectionIndex++;
    }
    if (newValueLength >= substrIndex) {
      newText.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
