// ignore_for_file: file_names

import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/user.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:doctolib/widget/dropdownWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool loading = false;
  bool _obscureText = true;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController txtNameController = TextEditingController();

  TextEditingController txtEmailController = TextEditingController();

  TextEditingController txtPasswordController = TextEditingController();

  TextEditingController txtAddressController = TextEditingController();

  TextEditingController txtNumberController = TextEditingController();
  String? civil = "mr";

  void registerUser() async {
    ApiResponse response = await register(
      civil!,
      txtNameController.text,
      txtAddressController.text,
      txtNumberController.text,
      txtEmailController.text,
      txtPasswordController.text,
      'client',
    );
    if (response.error == null) {
      _saveAndReutrnToLogin(response.data as User);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'vous êtes inscrits avec succès',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      setState(
        () {
          loading = !loading;
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

// save and reutrn to login
  void _saveAndReutrnToLogin(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (content) => const Login()),
      (route) => false,
    );
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
          children: [
            DropDownWidget(
              onValueChanged: (newValue) {
                // Recevoir la valeur mise à jour du widget enfant
                setState(() {
                  civil = newValue;
                  print("civil $civil");
                });
              },
            ),
            SizedBox(
              height: heigth * 0.020,
            ),
            TextFormField(
              controller: txtNameController,
              validator: (value) =>
                  value!.isEmpty ? 'nom et prénom est invalides' : null,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bleu,
                    width: 1,
                  ),
                ),
                prefixIcon: Icon(Icons.person_outline_outlined),
                prefixIconColor: bleu,
                labelText: 'Nom et prénom',
                labelStyle: TextStyle(
                  color: bleu,
                ),
                hintText: 'votre nom et prénom',
                hintStyle: TextStyle(
                  color: bleu,
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
              controller: txtAddressController,
              validator: (value) =>
                  value!.isEmpty ? 'Votre adresse est invalide' : null,
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bleu,
                    width: 1,
                  ),
                ),
                prefixIcon: Icon(Icons.home),
                prefixIconColor: bleu,
                labelText: 'Adresse',
                labelStyle: TextStyle(
                  color: bleu,
                ),
                hintText: 'votre adresse',
                hintStyle: TextStyle(
                  color: bleu,
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
              controller: txtNumberController,
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value!.isEmpty ? 'le numéro de téléphone invalide' : null,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bleu,
                    width: 1,
                  ),
                ),
                prefixIcon: Icon(Icons.phone),
                prefixIconColor: bleu,
                labelText: 'téléphone',
                labelStyle: TextStyle(
                  color: bleu,
                ),
                hintText: 'votre numéro de téléphone',
                hintStyle: TextStyle(
                  color: bleu,
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
              controller: txtEmailController,
              validator: (value) =>
                  value!.isEmpty ? 'Email est invalide' : null,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bleu,
                    width: 1,
                  ),
                ),
                prefixIcon: Icon(Icons.email),
                prefixIconColor: bleu,
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: bleu,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: bleu,
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
              controller: txtPasswordController,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) => value!.length < 6
                  ? 'Mot de passe doit êtres suppérieur à six(6) caractères'
                  : null,
              obscureText: _obscureText,
              maxLength: 8,
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
                hintText: 'Mot de passe',
                hintStyle: const TextStyle(
                  color: bleu,
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
            SizedBox(
              height: heigth * 0.020,
            ),
            TextFormField(
              obscureText: true,
              validator: (value) => value != txtPasswordController.text
                  ? 'Confirmer votre mot de passe'
                  : null,
              decoration: const InputDecoration(
                focusColor: bleu,
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: bleu,
                labelText: 'Confirmation de mot de passe',
                labelStyle: TextStyle(
                  color: bleu,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: bleu,
                    width: 1,
                  ),
                ),
                hintText: 'Confirmer votre mot de passe',
                hintStyle: TextStyle(
                  color: bleu,
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
            if (loading)
              // ignore: dead_code
              const Center(
                child: CircularProgressIndicator(),
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
                        loading = !loading;
                        registerUser();
                      });
                    }
                  },
                  child: Text(
                    "S'inscrire".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white70.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              child: Row(
                children: [
                  const Text(
                    "Si vous avez de compte,",
                    style: TextStyle(
                      color: bleu,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const Login(),
                        ),
                      );
                    },
                    child: const Text(
                      "connnectez-vous",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
