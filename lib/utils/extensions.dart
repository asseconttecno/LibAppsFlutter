import 'package:intl/intl.dart';



extension FormatesDateTime on DateTime? {
  String dateFormat({String? format}) {
    if(this == null ) return '';
    return DateFormat(format ?? 'dd/MM/yyyy', 'pt_BR').format(this!);
  }
}

extension FormatesDouble on double? {
  String real() {
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
}