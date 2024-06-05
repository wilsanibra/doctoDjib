/* import 'package:doctolib/constant.dart';
import 'package:doctolib/pages/login_page.dart'; */
import 'package:flutter/material.dart';

class AddUsersSecretaire extends StatefulWidget {
  String name = '';
  AddUsersSecretaire({
    super.key,
  });

  @override
  State<AddUsersSecretaire> createState() => _AddUsersSecretaireState();
}

class _AddUsersSecretaireState extends State<AddUsersSecretaire> {
  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            widget.name = value;
          },
          decoration: InputDecoration(labelText: 'Nom'),
        ),
      ],
    );
    ;
  }
}
