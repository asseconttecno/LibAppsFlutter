
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';


import '../../utils/validacoes.dart';
import '../config.dart';
import '../utils/cpf_email_formatter.dart';
import '../utils/cpf_rg_formatter.dart';
import '../utils/num_inputformatter.dart';
import 'custom_date_picker.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final Widget? icon;
  final void Function(String)? onFieldSubmitted;
  final void Function(DateTime)? onDateSaved;
  final bool textAlign;
  final bool isNext;
  final bool isBorder;
  final bool isClean;
  final String? hintText;
  final String? Function(String?)? validator;
  final FormType type;
  final double radius;
  final double? width;
  final Color? txtColor;
  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.title,
    this.icon,
    this.onFieldSubmitted,
    this.onDateSaved,
    this.textAlign = false,
    this.isNext = false,
    this.isBorder = true,
    this.isClean = false,
    this.hintText,
    this.validator,
    this.type = FormType.text,
    this.radius = 12,
    this.width,
    this.txtColor = Colors.white,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => FormProvider(),
      child: Consumer<FormProvider>(builder: (_, form, __) {
        return SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: textAlign
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                  child: Text(
                    title!,
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
              TextFormField(
                controller: controller,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                scrollPadding: EdgeInsets.zero,
                focusNode: focusNode,
                onSaved: (v) {
                  if (onDateSaved != null && v != null) {
                    final date = v.split('/');
                    onDateSaved!(DateTime(
                      int.parse(date.last),
                      int.parse(date[1]),
                      int.parse(date.first),
                    ));
                  }
                },
                onFieldSubmitted: onFieldSubmitted,
                textInputAction:
                isNext ? TextInputAction.next : TextInputAction.done,
                obscureText: type == FormType.pass,
                keyboardType: type == FormType.text || type == FormType.pass
                    ? TextInputType.text
                    : type == FormType.email || type == FormType.emailcpf
                    ? TextInputType.emailAddress
                    : TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: icon ??
                      (!isClean
                          ? null
                          : IconButton(
                        onPressed: () {
                          controller?.clear();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Config.corPribar,
                        ),
                      )),
                  fillColor: form.isError ? Colors.red.shade50 : Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  enabledBorder: OutlineInputBorder(
                      borderSide: isBorder
                          ? BorderSide(color: Colors.grey.shade300)
                          : BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  border: OutlineInputBorder(
                      borderSide: isBorder
                          ? BorderSide(color: Colors.grey.shade300)
                          : BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: isBorder
                          ? const BorderSide(
                        color: Config.corPribar,
                      )
                          : BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.redAccent.shade100),
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  errorStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: Colors.redAccent.shade100),
                  hintText: hintText ??
                      (type == FormType.cpf
                          ? '000.000.000-00'
                          : type == FormType.dinheiro
                          ? 'R\$0,00'
                          : type == FormType.num ||
                          type == FormType.numVigula
                          ? '0'
                          : type == FormType.rgcpf
                          ? 'RG/CPF'
                          : type == FormType.emailcpf
                          ? 'CPF/Email'
                          : type == FormType.pass
                          ? 'Digite a senha'
                          : type == FormType.phone
                          ? '(11) 98888-8888'
                          : type == FormType.email
                          ? 'email@email.com'
                          : type ==
                          FormType.date
                          ? 'DD/MM/AAAA'
                          : type ==
                          FormType.cnpj
                          ? '00.000.000/0001-00'
                          : type ==
                          FormType.cep
                          ? '00000-000'
                          : 'Digite ${title ?? 'valor'}'),
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                inputFormatters: _getInputFormatters(),
                validator: validator ?? _getDefaultValidator(context, form),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        );
      }),
    );
  }

  List<TextInputFormatter>? _getInputFormatters() {
    return type == FormType.cpf
        ? [
      FilteringTextInputFormatter.digitsOnly,
      CpfInputFormatter(),
    ]
        : type == FormType.rgcpf
        ? [
      FilteringTextInputFormatter.digitsOnly,
      CpfOrRGFormatter(),
    ]
        : type == FormType.emailcpf
        ? [
      CpfOrEmailFormatter(),
    ]
        : type == FormType.cep
        ? [
      FilteringTextInputFormatter.digitsOnly,
      CepInputFormatter(),
    ]
        : type == FormType.cnpj
        ? [
      FilteringTextInputFormatter.digitsOnly,
      CnpjInputFormatter(),
    ]
        : type == FormType.phone
        ? [
      FilteringTextInputFormatter.digitsOnly,
      TelefoneInputFormatter(),
    ]
        : type == FormType.date
        ? [
      FilteringTextInputFormatter.digitsOnly,
      DataInputFormatter(),
    ]
        : type == FormType.dinheiro ? [
      FilteringTextInputFormatter.digitsOnly,
      CentavosInputFormatter(),
    ] : type == FormType.num ? [
      FilteringTextInputFormatter.digitsOnly,
    ] : type == FormType.numVigula ? [
      NumInputFormatter.digitsOnly,
      NumInputFormatter(),
    ] : null;
  }

  String? Function(String?) _getDefaultValidator(BuildContext context, FormProvider form) {
    return (type == FormType.emailcpf ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o seu CPF/Email';
      } else if (!Validacoes.isCPF(v) && !Validacoes.emailValid(v)) {
        form.isError = true;
        return 'Digite CPF/Email valido';
      }
      form.isError = false;
      return null;
    } : type == FormType.cpf ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o seu CPF';
      } else if (!Validacoes.isCPF(v)) {
        form.isError = true;
        return 'Digite CPF valido';
      }
      form.isError = false;
      return null;
    } : type == FormType.dinheiro ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o valor';
      }
      form.isError = false;
      return null;
    } : type == FormType.num ? (v) {
      if (v == null || v == '' || !Validacoes.isNumeric(v)) {
        form.isError = true;
        return 'Digite numero';
      }
      form.isError = false;
      return null;
    } : type == FormType.numVigula ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o valor';
      }
      form.isError = false;
      return null;
    } : type == FormType.cnpj ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o seu CNPJ';
      } else if (v.length < 18) {
        form.isError = true;
        return 'Digite o seu CNPJ';
      }
      form.isError = false;
      return null;
    } : type == FormType.cep ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o seu CEP';
      } else if (v.length < 10) {
        form.isError = true;
        return 'Digite o seu CEP';
      }
      form.isError = false;
      return null;
    } : type == FormType.rgcpf ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o seu documento';
      } else if (v.length == 13) {
        form.isError = true;
        return 'Digite o seu CPF';
      } else if (v.length < 12) {
        form.isError = true;
        return 'Digite o seu RG/CPF';
      }
      form.isError = false;
      return null;
    } : type == FormType.phone ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o seu telefone';
      } else if (v.length < 14) {
        form.isError = true;
        return 'Digite o seu telefone';
      }
      form.isError = false;
      return null;
    } : type == FormType.email ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite seu email novo';
      } else if (!Validacoes
          .emailValid(v)) {
        form.isError = true;
        return 'Digite email valido!';
      }
      form.isError = false;
      return null;
    } : type == FormType.pass ? (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite sua senha';
      }
      form.isError = false;
      return null;
    } : type == FormType.date ? (v) {
      if (v == null || v == '' || v.length != 10) {
        form.isError = true;
        return 'Digite a data';
      } else if (!Validacoes.isDate(v)) {
        form.isError = true;
        return 'Digite uma data valida';
      }
      form.isError = false;
      return null;
    } : (v) {
      if (v == null || v == '') {
        form.isError = true;
        return 'Digite o $title';
      }
      form.isError = false;
      return null;
    });
  }
}

class CustomDateFormField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final DateTime? initDate;
  final bool textAlign;
  final bool isBorder;
  final Color? txtColor;
  final String? hintText;
  final double radius;
  final double? width;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final void Function(DateTime?)? onFieldSubmitted;
  final void Function(DateTime?)? onChanged;
  final void Function(DateTime?)? onSaved;

  const CustomDateFormField({
    super.key,
    required this.title,
    this.controller,
    this.initDate,
    this.textAlign = false,
    this.isBorder = true,
    this.txtColor,
    this.hintText,
    this.radius = 12,
    this.width,
    this.lastDate,
    this.firstDate,
    this.onFieldSubmitted,
    this.onChanged,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => FormProvider(),
      child: Consumer<FormProvider>(builder: (_, form, __) {
        return SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: textAlign
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                child: Text(title,
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
              DateTimeField(
                format: DateFormat("dd/MM/yyyy"),
                keyboardType: TextInputType.datetime,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                controller: controller,
                initialValue: initDate,
                onFieldSubmitted: onFieldSubmitted,
                onChanged: onChanged,
                onSaved: onSaved,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: hintText ?? "DD/MM/AAAA",
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  fillColor: form.isError ? Colors.red.shade50 : Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  enabledBorder: OutlineInputBorder(
                      borderSide: isBorder
                          ? BorderSide(color: Colors.grey.shade300)
                          : BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  border: OutlineInputBorder(
                      borderSide: isBorder
                          ? BorderSide(color: Colors.grey.shade300)
                          : BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: isBorder
                          ? const BorderSide(
                        color: Config.corPribar,
                      )
                          : BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.redAccent.shade100),
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                  errorStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: Colors.redAccent.shade100),
                  suffixIcon: const Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                  ),
                ),
                validator: (v) {
                  if (v == null) {
                    form.isError = true;
                    return 'Selecione uma data';
                  }
                  form.isError = false;
                  return null;
                },
                onShowPicker: (context, currentValue) {
                  return showCustomDatePicker(
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: lastDate ?? DateTime.now(),
                    firstDate: firstDate ?? DateTime(1900),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class FormProvider extends ChangeNotifier {
  bool _isError = false;
  bool get isError => _isError;
  set isError(bool v) {
    try {
      if (_isError != v) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _isError = v;
          notifyListeners();
        });
      }
    } catch (e) {
      _isError = v;
    }
  }
}

enum FormType {
  cpf,
  cnpj,
  cep,
  rgcpf,
  phone,
  email,
  emailcpf,
  pass,
  date,
  num,
  numVigula,
  dinheiro,
  text;
}
