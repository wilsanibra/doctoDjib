import 'package:doctolib/Form/RegisterForm.dart';
import 'package:doctolib/constant.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: myColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // section n°1
                Image.asset(
                  'assets/images/doctodjib.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                Text(
                  'Inscrivez-vous',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: bleu,
                    fontSize: MediaQuery.of(context).size.width / 22.5,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                // section n°2
                const RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
