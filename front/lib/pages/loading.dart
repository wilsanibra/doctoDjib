/* import 'dart:async'; */

import 'package:doctolib/pages/accueil_page.dart';
import 'package:doctolib/pages/admin/accueil_admin.dart';
import 'package:doctolib/pages/doctor/accueil_doctor.dart';
import 'package:doctolib/pages/secretaire/accueil_secretaire.dart';
/* import 'package:doctolib/services/appointment_service.dart'; */

import 'package:flutter/material.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'login_page.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String tokens = '';
  late User user;
  void _loadUserInfo() async {
    String token = await getToken();
    tokens = token;
    String role = await getRole();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (content) => const Login()),
        (route) => false,
      );
    } else {
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        user = response.data as User;
        // print('${user.name}');
        if (role == 'client') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (content) => Accueil(nomClient: user.name)),
            (route) => false,
          );
        } else if (role == 'admin') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (content) => adminAccueil(nomAdmin: user.name)),
            (route) => false,
          );
        } else if (role == 'secrétaire' || role == 'secretaire') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (content) =>
                    AccueilSecretaire(nomsecretaire: user.name)),
            (route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (content) => accueil_doctor(nomDoctor: user.name)),
            (route) => false,
          );
        }
      } else if (response.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (content) => const Login()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              '${response.error}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(
          color: bleu,
        ),
      ),
    );
  }
}
