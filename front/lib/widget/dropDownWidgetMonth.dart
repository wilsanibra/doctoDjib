import 'package:doctolib/constant.dart';
import 'package:doctolib/models/months.dart';
import 'package:flutter/material.dart';

class DropDownWidgetMonths extends StatefulWidget {
  final void Function(String) onValueChanged;
  DropDownWidgetMonths({super.key, required this.onValueChanged});

  @override
  State<DropDownWidgetMonths> createState() => _DropDownWidgetMonthsState();
}

class _DropDownWidgetMonthsState extends State<DropDownWidgetMonths> {
  String? months;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: months,
      onChanged: (String? newValue) {
        setState(() {
          months = newValue;
          widget.onValueChanged(months!);
        });
      },
      items: month.map((months) {
        return DropdownMenuItem(
          value: months.monthNumber,
          child: Text(
            months.name,
          ),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: "choisir",
        labelStyle: TextStyle(
          color: bleu,
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
