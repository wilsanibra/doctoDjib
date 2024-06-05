import 'package:doctolib/constant.dart';
import 'package:doctolib/models/years.dart';
import 'package:flutter/material.dart';

class DropDownWidgetYears extends StatefulWidget {
  final void Function(String) onValueChanged;
  const DropDownWidgetYears({super.key, required this.onValueChanged});

  @override
  State<DropDownWidgetYears> createState() => _DropDownWidgetYearsState();
}

class _DropDownWidgetYearsState extends State<DropDownWidgetYears> {
  String? years;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: years,
      onChanged: (String? newValue) {
        setState(() {
          years = newValue;
          widget.onValueChanged(years!);
        });
      },
      items: year.map((y) {
        return DropdownMenuItem(
          value: y.yearsNumbers,
          child: Text(
            y.yearsNumbers,
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
