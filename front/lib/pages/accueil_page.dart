import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/pages/fiche_page_client.dart';
import 'package:doctolib/pages/listeMedecin.dart';
import 'package:doctolib/pages/liste_apointment.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/pages/profile_page.dart';
import 'package:doctolib/services/user_service.dart';

// import 'package:doctolib/pages/rdv_page.dart';
import 'package:flutter/material.dart';

import '../services/appointment_service.dart';

class Accueil extends StatefulWidget {
  final String? nomClient;
  const Accueil({
    super.key,
    this.nomClient,
  });

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  int _currentindex = 0;
  bool loading = false;
  List<dynamic> apointmentsClients = [];
  List pages = [
    // const Rdv(),
    const ListeMedecin(),
    const Profile(),
    const listeApointment(),
    const FicheClientPage(),
  ];
  void _updatelisteApointment() async {
    int userId = await getUsrId();
    ApiResponse response = await updateListAppointmentClientModal(userId);
    if (response.error == null) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'fermeture avec succès',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: bleu,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
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

  void _appointmentList() async {
    int userId = await getUsrId();
    ApiResponse response = await getListAppointmentClientModal(userId);

    if (response.error == null) {
      setState(() {
        apointmentsClients = response.data as List<dynamic>;
        if (apointmentsClients.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Votre rendez-vous',
                  ),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        itemCount: apointmentsClients.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Text('du: ${apointmentsClients[index].date}'),
                            ],
                          );
                        },
                      ),
                    ),
                    const Text(
                      'a été annulé, veuillez voir avec votre medecin pour plus de détail, merci',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton.icon(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _updatelisteApointment();
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
        }
      });
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false)
        },
      );
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
    // TODO: implement initState
    _appointmentList();
    super.initState();
  }

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
            setState(() {
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
            });
          },
        ),
        title: Text(
          'Docto-Djib'.toUpperCase(),
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
                      title: Text(
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
            TabItem(icon: Icons.home),
            TabItem(icon: Icons.person),

            // TabItem(icon: Icons.calendar_month),
            TabItem(icon: Icons.list),
            TabItem(icon: Icons.receipt_outlined),
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
