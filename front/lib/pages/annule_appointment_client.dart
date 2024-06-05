import 'package:doctolib/constant.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/services/appointment_service.dart';
import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../services/user_service.dart';

class annuleAppointmentClient extends StatefulWidget {
  const annuleAppointmentClient({super.key});

  @override
  State<annuleAppointmentClient> createState() =>
      _annuleAppointmentClientState();
}

class _annuleAppointmentClientState extends State<annuleAppointmentClient> {
  List<dynamic> apointmentsClients = [];
  bool _loading = true;
  void _listeApointment() async {
    int userId = await getUsrId();
    ApiResponse response = await getListAppointmentClient(userId);
    if (response.error == null) {
      setState(() {
        apointmentsClients = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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

  @override
  void initState() {
    super.initState();
    _listeApointment();
  }

  final shadows = [
    BoxShadow(
      color: Colors.white70.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: ListView.builder(
                    itemCount: apointmentsClients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return apointmentsClients[index].status == 'Annuler'
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                                bottom: 5,
                                top: 3.5,
                              ),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  boxShadow: shadows,
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    color: bleu,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Avec: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: bleu,
                                            ),
                                          ),
                                          Text(
                                            'Dr ${apointmentsClients[index].name}',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Contact: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: bleu,
                                            ),
                                          ),
                                          Text(
                                            '${apointmentsClients[index].email}',
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const Text(
                                            '/',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            '${apointmentsClients[index].number}',
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Pour le: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: bleu,
                                            ),
                                          ),
                                          Text(
                                            ' ${apointmentsClients[index].date}',
                                          ),
                                          const Text(
                                            ' à: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: bleu,
                                            ),
                                          ),
                                          Text(
                                            '${apointmentsClients[index].time}',
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${apointmentsClients[index].status}',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  )),
            ],
          );
  }
}
