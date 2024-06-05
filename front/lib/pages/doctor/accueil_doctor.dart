import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:doctolib/constant.dart';
import 'package:doctolib/pages/agendaMedecin.dart';
import 'package:doctolib/pages/doctor/add_secretaire.dart';
import 'package:doctolib/pages/doctor/listPatientsDoctors.dart';
import 'package:doctolib/pages/doctor/listeRecommandationDoctor.dart';
import 'package:doctolib/pages/doctor/liste_appointment_doctor.dart';
import 'package:doctolib/pages/doctor/statistique.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/pages/profile_page.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/material.dart';

class accueil_doctor extends StatefulWidget {
  final String? nomDoctor;
  const accueil_doctor({
    super.key,
    this.nomDoctor,
  });

  @override
  State<accueil_doctor> createState() => _accueil_doctorState();
}

class _accueil_doctorState extends State<accueil_doctor> {
  int _currentindex = 0;
  bool loading = false;
  @override
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
          'Docteur ${widget.nomDoctor}'.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      Statistique(nomdoctor: widget.nomDoctor),
                ),
              );
            },
            icon: const Icon(
              Icons.bar_chart,
              color: Colors.white,
            ),
          ),
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pages[_currentindex],
      bottomNavigationBar: ConvexAppBar(
          activeColor: Colors.yellow,
          backgroundColor: bleu,
          style: TabStyle.reactCircle,
          items: const [
            // TabItem(icon: Icons.calendar_month_sharp),
            // TabItem(icon: Icons.home),
            TabItem(icon: Icons.list),
            TabItem(icon: Icons.person),
            TabItem(icon: Icons.calendar_month),
            TabItem(icon: Icons.comment),
            TabItem(icon: Icons.supervised_user_circle_sharp),
            TabItem(icon: Icons.add),

            // TabItem(icon: Icons.supervised_user_circle_sharp),
          ],
          initialActiveIndex: 0,
          onTap: (int index) {
            setState(
              () {
                _currentindex = index;
              },
            );
          }),
    );
  }
}
