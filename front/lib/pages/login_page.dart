import 'package:doctolib/constant.dart';
import 'package:flutter/material.dart';

import '../Form/LoginForm.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: myColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.06,
          ),
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
                  'Connexion',
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
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
