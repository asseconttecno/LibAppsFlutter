import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';


class DateRangeSelector extends StatelessWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final void Function(DateTimeRange) onChanged;

  const DateRangeSelector({
    super.key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onChanged,
  });

  void _showDateRangePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecionar Período'),
          content: BodyDataRange(
            onChanged: onChanged,
            initialStartDate: initialStartDate,
            initialEndDate: initialEndDate,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDateRangePicker(context),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('${initialStartDate.dateFormat(format: 'MM/yyyy')} - ${initialEndDate.dateFormat(format: 'MM/yyyy')}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class BodyDataRange extends StatefulWidget {
  const BodyDataRange({super.key, this.initialStartDate, this.initialEndDate, required this.onChanged});
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final void Function(DateTimeRange) onChanged;

  @override
  State<BodyDataRange> createState() => _BodyDataRangeState();
}

class _BodyDataRangeState extends State<BodyDataRange> {
  DateTime? startDate;
  DateTime? endDate;
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
  }


  Widget _buildDatePicker(String title, bool isStartDate) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButton<int>(
                hint: const Text('Ano'),
                value: isStartDate ? startDate?.year : endDate?.year,
                onChanged: (value) {
                  setState(() {
                    if (isStartDate) {
                      startDate = DateTime(value!, startDate?.month ?? 1);
                    } else {
                      endDate = DateTime(value!, endDate?.month ?? 1);
                    }
                    _adjustDates(isStartDate);
                  });
                },
                items: List.generate(
                  currentYear + 1 - 2020,
                      (index) => DropdownMenuItem(
                    value: 2020 + index,
                    child: Text((2020 + index).toString()),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButton<int>(
                hint: const Text('Mês'),
                value: isStartDate ? startDate?.month : endDate?.month,
                onChanged: (value) {
                  setState(() {
                    if (isStartDate) {
                      startDate = DateTime(startDate?.year ?? currentYear, value!);
                    } else {
                      endDate = DateTime(endDate?.year ?? currentYear, value!);
                    }
                    _adjustDates(isStartDate);
                  });
                },
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(DateTime(0, index + 1).dateFormat(format: 'MMMM').toUpperCase()),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _adjustDates(bool isStartDate) {
    if (startDate != null && endDate != null) {
      // Se 'isStartDate' for verdadeiro, estamos ajustando a data de início
      if (isStartDate) {
        // Ajustar a data de início se ela for posterior à data de fim
        if (startDate!.isAfter(endDate!)) {
          startDate = endDate;
        }

        // Verificar se o intervalo é maior que 12 meses e ajustar a data de fim
        int monthDifference = (endDate!.year - startDate!.year) * 12 + (endDate!.month - startDate!.month);
        if (monthDifference > 12) {
          endDate = startDate.addMonths(12);
        }

      } else {
        // Caso 'isStartDate' seja falso, ajustamos a data de fim
        // Ajustar a data de fim se for anterior à data de início
        if (endDate!.isBefore(startDate!)) {
          endDate = startDate;
        }

        // Verificar se o intervalo é maior que 12 meses e ajustar a data de início
        int monthDifference = (endDate!.year - startDate!.year) * 12 + (endDate!.month - startDate!.month);
        if (monthDifference > 12) {
          startDate = endDate.addMonths(-12);
        }
      }

      // Ajustar a data de fim para não exceder o mês atual
      if (endDate!.year > currentYear || (endDate!.year == currentYear && endDate!.month > currentMonth)) {
        endDate = DateTime(currentYear, currentMonth);
      }

      // Ajustar a data de fim para não exceder o mês atual
      if (startDate!.year > currentYear || (startDate!.year == currentYear && startDate!.month > currentMonth)) {
        startDate = DateTime(currentYear, currentMonth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDatePicker('Início', true),
          const SizedBox(height: 20),
          _buildDatePicker('Fim', false),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Chama o método onChanged apenas quando o botão de confirmar é clicado
                  if (startDate != null && endDate != null) {
                    widget.onChanged(DateTimeRange(start: startDate!, end: endDate!));
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
