import 'package:doctolib/constant.dart';
import 'package:doctolib/pages/admin/accueil_admin.dart';
import 'package:doctolib/pages/doctor/accueil_doctor.dart';
import 'package:doctolib/pages/register_page.dart';
import 'package:doctolib/pages/secretaire/accueil_secretaire.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';
import '../models/user.dart';
import '../pages/accueil_page.dart';
import '../services/user_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;
  bool _obscureText = true;

  void _onLogin() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    // _appointmentListModalLogin();
    if (response.error == null) {
      setState(() {
        _saveAndRedirectHome(response.data as User);
      });
    } else {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '${response.error}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void _saveAndRedirectHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setString('role', user.specialityType ?? '');
    if (user.specialityType == 'client') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (content) => Accueil(nomClient: user.name)),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'connexion avec succès',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (user.specialityType == 'admin') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (content) => adminAccueil(nomAdmin: user.name)),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'connexion avec succès',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (user.specialityType == 'secrétaire' ||
        user.specialityType == 'secretaire') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (content) => AccueilSecretaire(nomsecretaire: user.name)),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'connexion avec succès',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (content) => accueil_doctor(nomDoctor: user.name)),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'connexion avec succès',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Form(
      key: formkey,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width / 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) =>
                  val!.isEmpty ? "veuillez remplir ce champ" : null,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bleu,
                    width: 1,
                  ),
                ),
                prefixIcon: Icon(Icons.email),
                prefixIconColor: bleu,
                labelText: 'Adresse email',
                labelStyle: TextStyle(
                  color: bleu,
                ),
                hintText: 'votre adresse email',
                hintStyle: TextStyle(
                  color: bleu,
                  // fontSize: width / 25,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: bleu,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: heigth * 0.020,
            ),
            TextFormField(
              controller: txtPassword,
              validator: (val) => val!.length < 6
                  ? "votre mot de passe n'est pas validé"
                  : null,
              obscureText: _obscureText,
              decoration: InputDecoration(
                focusColor: bleu,
                prefixIcon: const Icon(Icons.lock),
                prefixIconColor: bleu,
                labelText: 'Mot de passe',
                labelStyle: const TextStyle(
                  color: bleu,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bleu,
                    width: 1,
                  ),
                ),
                hintText: 'votre mot de passe',
                hintStyle: const TextStyle(
                  color: bleu,
                  // fontSize: width / 25,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: bleu,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(
                      () {
                        _obscureText = !_obscureText;
                      },
                    );
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: bleu,
                  ),
                ),
              ),
            ),
            // const Align(
            //   alignment: Alignment.bottomRight,
            //   child: TextButton(
            //     onPressed: null,
            //     child: Text(
            //       'Forgot Password ?',
            //       style: TextStyle(
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: heigth * 0.020,
            ),

            if (loading)
              const Center(
                child: CircularProgressIndicator(
                  color: bleu,
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: heigth / 17,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      bleu,
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _onLogin();
                      });
                    }
                  },
                  child: Text(
                    'Se Connecter'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white70.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: heigth * 0.025,
            ),
            Row(
              children: [
                const Text(
                  "si vous n'avez pas de compte",
                  style: TextStyle(
                    color: bleu,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const Register(),
                      ),
                    );
                  },
                  child: const Text(
                    " inscrivez-vous",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
