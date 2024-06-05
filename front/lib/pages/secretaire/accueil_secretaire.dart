import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:awesome_stepper/awesome_stepper.dart';
import 'package:doctolib/constant.dart';
import 'package:doctolib/pages/doctor/add_secretaire.dart';
import 'package:doctolib/pages/doctor/listPatientsDoctors.dart';
import 'package:doctolib/pages/doctor/listeRecommandationDoctor.dart';
import 'package:doctolib/pages/doctor/liste_appointment_doctor.dart';
import 'package:doctolib/pages/listeMedecin.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/pages/profile_page.dart';
import 'package:doctolib/pages/secretaire/add_user_secretaire.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../Form/RegisterForm.dart';
import '../agendaMedecin.dart';

class AccueilSecretaire extends StatefulWidget {
  final String? nomsecretaire;
  const AccueilSecretaire({super.key, this.nomsecretaire});

  @override
  State<AccueilSecretaire> createState() => _AccueilSecretaireState();
}

class _AccueilSecretaireState extends State<AccueilSecretaire> {
  int currentStep = 0;
  bool loading = false;
  List<AwesomeStepperItem> steps = [
    AwesomeStepperItem(
      label: 'Enregistrer client',
      content: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AddUsersSecretaire(),
          )
        ],
      ),
      // content: Container(
      //   alignment: Alignment.center,
      //   child: const Text('Step 1'),
      // ),
    ),
    AwesomeStepperItem(
      label: 'Step 2',
      content: Container(
        alignment: Alignment.center,
        child: const Text('Step 2'),
      ),
    ),
  ];
  List pages = [
    // const ListeMedecinAdmin(),
    const listeAppointmentDoctors(),
    const Profile(),
    const agendaMedecin(),
    const listRecommandationDoctors(),
    const listPatientsDoctors(),
    const AddSecretaire(),
    // const listAppointment(),
    // const ListUsers(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bleu,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.help),
          color: Colors.white,
          onPressed: () {
            setState(
              () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'A propos',
                        ),
                      ],
                    ),
                    content: const Text(
                      'DoctoDjib est une application web et mobile pour prendre des rendez-vous en ligne avec le docteur de votre choix. Merci beaucoup de la télécharger',
                    ),
                    actions: [
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Fermer',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        title: Text(
          'Secrétaire'.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                        'Deconnection',
                      ),
                      content: const Text(
                        'Voulez-vous vraiment se déconnecter ?',
                      ),
                      actions: [
                        ElevatedButton.icon(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Annuler',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Colors.red,
                            ),
                          ),
                          onPressed: () {
                            logout().then(
                              (value) =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (content) => const Login(),
                                ),
                                (route) => false,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.white,
                                content: Text(
                                  'vous êtes déconnectés avec succès',
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
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Deconnecter',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: ListeMedecin(nomSecretaire: widget.nomsecretaire),
    );
  }
}
