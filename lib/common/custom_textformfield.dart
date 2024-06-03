
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
import 'custom_date_picker.dart';


class CustomTextFormField {
  static Widget custom({
    TextEditingController? controller,
    String? title,
    Widget? icon,
    void Function(String)? onFieldSubmitted,
    void Function(DateTime)? onDateSaved,
    bool textAlign = false,
    bool isNext = false,
    bool isBorder = true,
    bool isClean = false,
    String? hintText,
    String? Function(String?)? validator,
    FormType type = FormType.text,
    double radius = 12,
    double? width,
    Color? txtColor = Colors.white,
    FocusNode? focusNode,
  }) {
    return Consumer<FormProvider>(
        builder: (context, form, __) {
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
                  title,
                  style: TextStyle(
                      color: txtColor,
                      fontSize: textAlign ? 18 : 14,
                      fontWeight: FontWeight.w600),
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
                  onDateSaved(DateTime(int.parse(date.last),
                      int.parse(date[1]), int.parse(date.first)));
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
                            ))),
                fillColor: form.isError ? Colors.red.shade100 : Colors.white,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                enabledBorder: OutlineInputBorder(
                    borderSide: isBorder
                        ? BorderSide(color: Colors.grey.shade300)
                        : BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(radius))
                ),
                border: OutlineInputBorder(
                    borderSide: isBorder
                        ? BorderSide(color: Colors.grey.shade300)
                        : BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(radius))
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: isBorder
                        ? const BorderSide(color: Config.corPribar,)
                        : BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(radius))
                ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent.shade100),
                    borderRadius: BorderRadius.all(Radius.circular(radius))),
                errorStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Colors.redAccent.shade100),
                hintText: hintText ??
                    (type == FormType.cpf
                        ? '000.000.000-00'
                        : type == FormType.rgcpf
                            ? 'RG/CPF'
                        : type == FormType.emailcpf
                        ? 'CPF/Email'
                            : type == FormType.pass
                                ? '********'
                                : type == FormType.phone
                                    ? '(11) 98888-8888'
                                    : type == FormType.email
                                        ? 'email@email.com'
                                        : type == FormType.date
                                            ? 'DD/MM/AAAA'
                                            : type == FormType.cnpj
                                                ? '00.000.000/0001-00'
                                                : type == FormType.cep
                                                    ? '00000-000'
                                                    : 'Digite ${title ?? 'valor'}'),
                hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              inputFormatters: type == FormType.cpf
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
                                      : null,
              validator: validator ??
                  (type == FormType.emailcpf
                  ? (v) {
                    if (v == null || v == '') {
                      form.isError = true;
                      return 'Digite o seu CPF/Email';
                    } else if (!Validacoes.isCPF(v) && !Validacoes.emailValid(v)) {
                      form.isError = true;
                      return 'Digite CPF/Email valido';
                    }
                    form.isError = false;
                    return null;
                  } : type == FormType.cpf
                      ? (v) {
                          if (v == null || v == '') {
                            form.isError = true;
                            return 'Digite o seu CPF';
                          } else if (!Validacoes.isCPF(v)) {
                            form.isError = true;
                            return 'Digite CPF valido';
                          }
                          form.isError = false;
                          return null;
                        }
                      : type == FormType.cnpj
                          ? (v) {
                              if (v == null || v == '') {
                                form.isError = true;
                                return 'Digite o seu CNPJ';
                              } else if (v.length < 18) {
                                form.isError = true;
                                return 'Digite o seu CNPJ';
                              }
                              form.isError = false;
                              return null;
                            }
                          : type == FormType.cep
                              ? (v) {
                                  if (v == null || v == '') {
                                    form.isError = true;
                                    return 'Digite o seu CEP';
                                  } else if (v.length < 10) {
                                    form.isError = true;
                                    return 'Digite o seu CEP';
                                  }
                                  form.isError = false;
                                  return null;
                                }
                              : type == FormType.rgcpf
                                  ? (v) {
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
                                    }
                                  : type == FormType.phone
                                      ? (v) {
                                          if (v == null || v == '') {
                                            form.isError = true;
                                            return 'Digite o seu telefone';
                                          } else if (v.length < 14) {
                                            form.isError = true;
                                            return 'Digite o seu telefone';
                                          }
                                          form.isError = false;
                                          return null;
                                        }
                                      : type == FormType.email
                                          ? (v) {
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
                                            }
                                          : type == FormType.pass
                                              ? (v) {
                                                  if (v == null || v == '') {
                                                    form.isError = true;
                                                    return 'Digite sua senha';
                                                  }else if (v.length < 6) {
                                                    form.isError = true;
                                                    return 'Senha deve conter no minimo 6 caracteres';
                                                  }
                                                  form.isError = false;
                                                  return null;
                                                }
                                              : type == FormType.date
                                                  ? (v) {
                                                      if (v == null ||
                                                          v == '' ||
                                                          v.length != 10) {
                                                        form.isError = true;
                                                        return 'Digite a data';
                                                      } else if (!Validacoes
                                                          .isDate(v)) {
                                                        form.isError = true;
                                                        return 'Digite uma data valida';
                                                      }
                                                      form.isError = false;
                                                      return null;
                                                    }
                                                  : (v) {
                                                      if (v == null ||
                                                          v == '') {
                                                        form.isError = true;
                                                        return 'Digite o $title';
                                                      }
                                                      form.isError = false;
                                                      return null;
                                                    }),
            ),
          ],
        ),
      );
    });
  }

  static Widget date(
      {required TextEditingController controller,
      required String title,
      bool textAlign = false,
      bool isBorder = false,
      Color? txtColor,
      String? hintText,
      double radius = 12,
      double? width}) {
    return Consumer<FormProvider>(
        builder: (context, form, __) {
      return SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: textAlign
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 5, top: 5, bottom: textAlign ? 5 : 0),
              child: Text(
                title,
                style: TextStyle(
                    color: txtColor,
                    fontSize: textAlign ? 18 : 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            DateTimeField(
              format: DateFormat("dd/MM/yyyy"),
              keyboardType: TextInputType.datetime,
              style: const TextStyle(fontSize: 12),
              controller: controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
              decoration: InputDecoration(
                hintText: "DD/MM/AAAA",
                contentPadding: const EdgeInsets.only(left: 15, top: 6),
                fillColor: form.isError ? Colors.red.shade100 : Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: isBorder
                        ? const BorderSide(color: Config.corPribar,)
                        : BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(radius))),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent.shade100),
                    borderRadius: BorderRadius.all(Radius.circular(radius))),
                errorStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Colors.redAccent.shade100),
                suffixIcon: const Icon(
                  Icons.calendar_month,
                  color: Config.corPribar,
                ),
              ),
              validator: (v) {
                if (v == null || v == '') {
                  form.isError = true;
                  return 'Selecione sua data de aniversario';
                }
                form.isError = false;
                return null;
              },
              onShowPicker: (context, currentValue) {
                return showCustomDatePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialDate: currentValue ??
                      DateTime.now().subtract(const Duration(days: 6570)),
                  lastDate: DateTime.now(),
                  firstDate: DateTime(1900),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

class FormProvider extends ChangeNotifier {
  bool _isError = false;
  bool get isError => _isError;
  set isError(bool v) {
    if (_isError != v) {
      _isError = v;
      notifyListeners();
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
  text;
}
