import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/user.dart';
import 'package:doctolib/pages/admin/accueil_admin.dart';
import 'package:doctolib/services/cabinet_service.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class addUsersAdmin extends StatefulWidget {
  const addUsersAdmin({super.key});

  @override
  State<addUsersAdmin> createState() => _addUsersAdminState();
}

class _addUsersAdminState extends State<addUsersAdmin> {
  late User users;
  bool loading = false;
  bool _obscureText = true;
  List<dynamic> cabinet = [];
  // late String _selectedCabinte;
  List<int> _selectedCabinte = [];
  List<MultiSelectItem<dynamic>> items = [];
  final text = "pas de cabinet";
  final GlobalKey<FormState> formkey2 = GlobalKey<FormState>();

  TextEditingController txtNameController2 = TextEditingController();

  TextEditingController txtEmailController2 = TextEditingController();

  TextEditingController txtPasswordController2 = TextEditingController();

  TextEditingController txtAddressController2 = TextEditingController();

  TextEditingController txtNumberController2 = TextEditingController();
  TextEditingController txtSpecialtyController2 = TextEditingController();

  void registerUser2() async {
    ApiResponse response = await registerDocto(
      txtNameController2.text,
      txtAddressController2.text,
      _selectedCabinte.toString(),
      txtNumberController2.text,
      txtEmailController2.text,
      txtPasswordController2.text,
      txtSpecialtyController2.text,
    );
    if (response.error == null) {
      setState(() {
        _saveAndReutrnToAccueil(response.data as Userdocto);
      });
    } else {
      setState(
        () {
          loading = !loading;
        },
      );
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

// GET aLL cabinet
  void _getAllCabinet() async {
    ApiResponse response = await getAllCabinet();
    if (response.error == null) {
      setState(() {
        cabinet = response.data as List<dynamic>;
        items = cabinet.map((e) => MultiSelectItem(e, e.nomCab)).toList();
      });
    } else {}
  }

// save and reutrn to login
  void _saveAndReutrnToAccueil(Userdocto user) async {
    ApiResponse response = await getUserDetail();
    users = response.data as User;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (content) => adminAccueil(nomAdmin: users.name),
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
  void initState() {
    _getAllCabinet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    /* double width = MediaQuery.of(context).size.width; */
    // final items = cabinet
    //     .map((c) => MultiSelectItem<dynamic>(cabinet, c.nomCab))
    //     .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const Center(
            child: Text(
              'Ajouter un Medecin',
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
                MultiSelectDialogField(
                  validator: (val) => val!.isEmpty
                      ? "aucun cabinet selectioner ou vide dans la base"
                      : null,
                  chipDisplay: MultiSelectChipDisplay(scroll: true),
                  title: const Text(
                    'Cabinet',
                    style: TextStyle(
                      color: bleu,
                    ),
                  ),
                  buttonText: const Text(
                    'Cabinet',
                    style: TextStyle(
                      color: bleu,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: bleu,
                    ),
                  ),
                  items: items,
                  listType: MultiSelectListType.CHIP,
                  // validator: (value) =>
                  //     value!.isEmpty ? "votre nom est invalide" : null,
                  onConfirm: (values) {
                    _selectedCabinte = values
                        .map(
                          (e) => int.parse(
                            e.id.toString(),
                          ),
                        )
                        .toList();
                    // _selectedCabinte = values.map((e) => e.id).join(",");
                    // var tempVar = values.map((e) => e.id).toList();
                    // print(tempVar);
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
                  controller: txtSpecialtyController2,
                  keyboardType: TextInputType.text,
                  validator: (value) => value!.isEmpty
                      ? 'Spécialité ne doit pas être vide'
                      : null,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: bleu,
                        width: 1,
                      ),
                    ),
                    prefixIcon: Icon(Icons.add),
                    prefixIconColor: bleu,
                    labelText: 'spécialité',
                    labelStyle: TextStyle(
                      color: bleu,
                    ),
                    hintText: 'votre spécialité',
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
                            print('${_selectedCabinte.toString()}');
                            loading = !loading;
                            registerUser2();
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
