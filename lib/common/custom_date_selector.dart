import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';


class DateSelector extends StatelessWidget {
  final DateTime? initialStartDate;
  final void Function(DateTime) onChanged;
  final String? title;
  final Color? textColor;

  const DateSelector({
    super.key,
    required this.initialStartDate,
    required this.onChanged,
    this.title,
    this.textColor = Colors.white,
  });

  void _showDateRangePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Selecionar Data'),
          content: BodyData(
            onChanged: onChanged,
            initialStartDate: initialStartDate,
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
        child: Text(initialStartDate?.dateFormat(format: 'MM/yyyy') ?? 'Selecione a competência',
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

class BodyData extends StatefulWidget {
  const BodyData({super.key, this.initialStartDate, required this.onChanged});
  final DateTime? initialStartDate;
  final void Function(DateTime) onChanged;

  @override
  State<BodyData> createState() => _BodyDataState();
}

class _BodyDataState extends State<BodyData> {
  late DateTime startDate;
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate ?? DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Data', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Ano'),
                      value: startDate.year ,
                      onChanged: (value) {
                        setState(() {
                          startDate = DateTime(value!, startDate.month);
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
                      value: startDate.month,
                      onChanged: (value) {
                        setState(() {
                          startDate = DateTime(startDate.year, value!);
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
          ),
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
                  widget.onChanged(startDate);
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
