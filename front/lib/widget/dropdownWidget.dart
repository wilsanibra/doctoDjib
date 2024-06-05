import 'package:doctolib/constant.dart';
import 'package:doctolib/models/civility.dart';
import 'package:doctolib/models/date.dart';
import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  bool? inDesign;
  final void Function(String) onValueChanged;
  DropDownWidget({
    super.key,
    required this.onValueChanged,
    this.inDesign,
  });

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? civility;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: civility,
      onChanged: (String? newValue) {
        setState(() {
          civility = newValue;
          widget.onValueChanged(civility!);
        });
      },
      items: widget.inDesign == false
          ? date.map((dates) {
              return DropdownMenuItem(
                value: dates.name,
                child: Text(
                  dates.traduction,
                ),
              );
            }).toList()
          : civilities.map((civility) {
              return DropdownMenuItem(
                value: civility.name,
                child: Text(
                  civility.name,
                ),
              );
            }).toList(),
      decoration: InputDecoration(
        labelText: widget.inDesign == false ? "choisir" : "Genre",
        labelStyle: const TextStyle(
          color: bleu,
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
