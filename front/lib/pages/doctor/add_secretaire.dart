import 'package:doctolib/constant.dart';
import 'package:doctolib/models/user.dart';
import 'package:doctolib/pages/doctor/accueil_doctor.dart';
import 'package:doctolib/widget/dropdownWidget.dart';
import 'package:flutter/material.dart';

import '../../models/api_response.dart';
import '../../services/user_service.dart';

class AddSecretaire extends StatefulWidget {
  const AddSecretaire({super.key});

  @override
  State<AddSecretaire> createState() => _AddSecretaireState();
}

class _AddSecretaireState extends State<AddSecretaire> {
  late User users;
  bool loading = false;
  bool _obscureText = true;
  final GlobalKey<FormState> formkey2 = GlobalKey<FormState>();

  TextEditingController txtNameController2 = TextEditingController();

  TextEditingController txtEmailController2 = TextEditingController();

  TextEditingController txtPasswordController2 = TextEditingController();

  TextEditingController txtAddressController2 = TextEditingController();

  TextEditingController txtNumberController2 = TextEditingController();
  String? civil = "mr";
  // TextEditingController txtSpecialtyController2 = TextEditingController();
  void registerSecretaire() async {
    ApiResponse response = await register(
      txtNameController2.text,
      txtAddressController2.text,
      txtNumberController2.text,
      civil!,
      txtEmailController2.text,
      txtPasswordController2.text,
      'secrétaire',
    );
    if (response.error == null) {
      _saveAndReutrnToAccueil(response.data as User);
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
  void _saveAndReutrnToAccueil(User user) async {
    ApiResponse response = await getUserDetail();
    users = response.data as User;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (content) => accueil_doctor(nomDoctor: users.name),
      ),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'le medecin est enrégistré avec succes',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color.fromARGB(
              255,
              43,
              89,
              109,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const Center(
            child: Text(
              'Ajouter votre secrétaire',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: bleu,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: formkey2,
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
                  controller: txtNameController2,
                  validator: (value) =>
                      value!.isEmpty ? "votre nom est invalide" : null,
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
                  controller: txtAddressController2,
                  validator: (value) =>
                      value!.isEmpty ? 'votre adresse est invalide' : null,
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
                    labelText: 'adresse',
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
                  controller: txtNumberController2,
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
                    hintText: 'votre téléphone',
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
                  controller: txtEmailController2,
                  validator: (value) =>
                      value!.isEmpty ? 'adresse email est invalide' : null,
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
                  controller: txtPasswordController2,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) => value!.length < 6
                      ? 'le Mot de passe doit être plus de six(6) caractères'
                      : null,
                  obscureText: _obscureText,
                  maxLength: 8,
                  decoration: InputDecoration(
                    focusColor: bleu,
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: bleu,
                    labelText: 'Mote de passe',
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
                  validator: (value) => value != txtPasswordController2.text
                      ? 'Confirmation de mot de passe'
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
                        if (formkey2.currentState!.validate()) {
                          setState(() {
                            loading = !loading;
                            registerSecretaire();
                          });
                        }
                      },
                      child: Text(
                        'Enregsitrer'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white70.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
