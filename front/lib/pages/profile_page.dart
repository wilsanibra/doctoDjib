import 'dart:io';

import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/user.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';
import 'login_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = true;
  bool _obscureText = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  Uint8List webImage = Uint8List(8);
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtAdresseController = TextEditingController();
  TextEditingController txtNumberController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  User? user;
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _getUserDetails() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
        txtAdresseController.text = user!.address ?? '';
        txtEmailController.text = user!.email ?? '';
        txtNumberController.text = user!.number ?? '';
      });
    } else {}
  }

  //update profile
  void updateProfile() async {
    ApiResponse response = await updateUser(
      txtNameController.text,
      txtAdresseController.text,
      txtNumberController.text,
      txtEmailController.text,
      txtPasswordController.text,
      getStringImage(_imageFile),
    );
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            '${response.data}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
                (route) => false)
          });
    } else {
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

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    return loading
        ? const Center(
            child: CircularProgressIndicator(
              color: bleu,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: _imageFile == null
                            ? user!.image != null
                                ? DecorationImage(
                                    image: NetworkImage('${user!.image}'),
                                    fit: BoxFit.cover)
                                : const DecorationImage(
                                    image: AssetImage('assets/images/man.png'),
                                    fit: BoxFit.cover)
                            : DecorationImage(
                                image: FileImage(_imageFile ?? File('')),
                                fit: BoxFit.cover),
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: bleu,
                        ),
                      ),
                    ),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: txtNameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Nom invalide' : null,
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
                          labelText: 'Nom',
                          labelStyle: TextStyle(
                            color: bleu,
                          ),
                          hintText: 'votre nom',
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
                        controller: txtAdresseController,
                        validator: (value) =>
                            value!.isEmpty ? 'Adresse invalide' : null,
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
                            value!.isEmpty ? 'numéro téléphone invalide' : null,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: bleu,
                              width: 1,
                            ),
                          ),
                          prefixIcon: Icon(Icons.phone),
                          prefixIconColor: bleu,
                          labelText: 'Téléphone',
                          labelStyle: TextStyle(
                            color: bleu,
                          ),
                          hintText: 'votre numéro',
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
                            value!.isEmpty ? 'Email invalide' : null,
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
                            ? 'le mot de passe doit êtres supérieur à six(6) caractères'
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
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                        validator: (value) =>
                            value != txtPasswordController.text
                                ? 'Confirmer votre Mot de passe'
                                : null,
                        decoration: const InputDecoration(
                          focusColor: bleu,
                          prefixIcon: Icon(Icons.lock),
                          prefixIconColor: bleu,
                          labelText: 'Confirmation de Mot de passe',
                          labelStyle: TextStyle(
                            color: bleu,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: bleu,
                              width: 1,
                            ),
                          ),
                          hintText: 'Confirmation de Mot de passe',
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
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  loading = !loading;
                                  updateProfile();
                                });
                              }
                            },
                            child: Text(
                              'Modifier'.toUpperCase(),
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
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
  }
}
