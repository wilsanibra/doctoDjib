import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckboxWidget extends StatefulWidget {
  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  List<String> _selectedOptions = [];
  List<dynamic> _options = [];

  @override
  void initState() {
    super.initState();
    _fetchOptions();
  }

  void _fetchOptions() async {
    final response =
        await http.get(Uri.parse('https://your-api-url.com/options'));
    final data = jsonDecode(response.body);
    setState(() {
      _options = data['options'];
    });
  }

  void _toggleOption(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
  }

  void _submitOptions() async {
    /* final response =
        await http.post(Uri.parse('https://your-api-url.com/options'), body: {
      'selectedOptions': jsonEncode(_selectedOptions),
    }); */
    // handle response from Laravel API
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose one or more options:'),
        Column(
          children: _options.map((option) {
            final String label = option['label'];
            final String value = option['value'];
            final bool isSelected = _selectedOptions.contains(value);
            return CheckboxListTile(
              title: Text(label),
              value: isSelected,
              onChanged: (selected) => _toggleOption(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: _submitOptions,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
