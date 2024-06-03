import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';

import 'package:assecontservices/utils/validacoes.dart';

import 'package:brasil_fields/src/formatters/compound_formatters/compound_formatter.dart';
import 'package:brasil_fields/src/formatters/cpf_input_formatter.dart';
import 'package:brasil_fields/src/interfaces/compoundable_formatter.dart';



class CpfOrEmailFormatter extends TextInputFormatter {
  final CpfInputFormatter cpfFormatter = CpfInputFormatter();
  final EmailInputFormatter emailFormatter = EmailInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (CPFValidator.isValid(newValue.text)) {
      print('cpfFormatter');
      return cpfFormatter.formatEditUpdate(oldValue, newValue);
    } else {
      print('emailFormatter');
      return emailFormatter.formatEditUpdate(oldValue, newValue);
    }
  }
}

class EmailInputFormatter extends TextInputFormatter {


  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.trim().toLowerCase();
    int selectionIndex = newValue.selection.end;

    // Apply basic mask by removing spaces and converting to lowercase
    if (text.contains(' ')) {
      text = text.replaceAll(' ', '');
      selectionIndex = text.length;
    }

    if (Validacoes.emailValid(text) || text.isEmpty) {
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: selectionIndex),
      );
    }
    return newValue;
  }
}

class CpfOrEmailFormatter2 extends CompoundFormatter {
  CpfOrEmailFormatter2() : super([CpfInputFormatter(), EmailInputFormatter2()]);
}


class EmailInputFormatter2 extends TextInputFormatter implements CompoundableFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty || Validacoes.emailValid(newValue.text) ) {
      return newValue;
    }
    return newValue;
  }

  @override
  // TODO: implement maxLength
  int get maxLength => 50;
}
