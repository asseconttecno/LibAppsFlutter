import 'package:intl/intl.dart';



extension FormatesDateTime on DateTime? {
  String dateFormat({String? format}) {
    if(this == null ) return '';
    return DateFormat(format ?? 'dd/MM/yyyy', 'pt_BR').format(this!);
  }

  DateTime addMonths(int monthsToAdd) {
    DateTime originalDate;
    if(this == null) {
      originalDate = DateTime.now();
    } else {
      originalDate = this!;
    }
    if(monthsToAdd == 0) return originalDate;


    int newYear = originalDate.year;
    int newMonth = originalDate.month + monthsToAdd;

    // Ajusta o ano e o mês caso o novo mês seja maior que 12 ou menor que 1
    while (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    while (newMonth < 1) {
      newYear--;
      newMonth += 12;
    }

    int day = originalDate.day;
    int maxDay = DateTime(newYear, newMonth + 1, 0).day; // Último dia do novo mês

    // Ajusta o dia caso seja maior que o último dia do novo mês
    if (day > maxDay) {
      day = maxDay;
    }

    return DateTime(newYear, newMonth, day, originalDate.hour, originalDate.minute, originalDate.second);
  }
}

extension FormatesDouble on double? {
  String real() {
    if(this == 0) return 'R\$0,00';
    var _mask = NumberFormat.currency(locale: 'pt_Br', customPattern: 'R\$#,##0.00');
    return _mask.format(this ?? 0);
  }
}

extension FormatesString on String? {
  double toDouble() {
    if(this == null) return 0;
    final d = double.tryParse(this!.replaceAll('.', '').replaceAll(',', '.'));
    return d ?? 0;
  }

  DateTime? toDate() {
    if(this == null) return null;
    final l = this!.split('/');
    return DateTime(int.parse(l[2]), int.parse(l[1]), int.parse(l[0]));
  }
}