import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/services/appointment_service.dart';
import 'package:flutter/material.dart';

class AppointementClients extends StatefulWidget {
  const AppointementClients({super.key});

  @override
  State<AppointementClients> createState() => _AppointementClientsState();
}

class _AppointementClientsState extends State<AppointementClients> {
  List<dynamic> _appointmentClients = [];
  bool _loading = true;

  void _getAllAppointementClients() async {
    ApiResponse response = await AllAppoinmentClients();
    if (response.error == null) {
      setState(() {
        _appointmentClients = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else {
      print('tsy ao');
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllAppointementClients();
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
        : ListView.builder(
            itemCount: _appointmentClients.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 5,
                  top: 3.5,
                ),
                child: Container(
                  height: 130,
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
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Monsieur / Madame: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bleu,
                              ),
                            ),
                            Text(
                              '${_appointmentClients[index].name}',
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
                              '${_appointmentClients[index].email} / ${_appointmentClients[index].number}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Spécialités: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bleu,
                              ),
                            ),
                            Text(
                              ' ${_appointmentClients[index].specialty}',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'A un rendez-vous le: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bleu,
                              ),
                            ),
                            Text(
                              ' ${_appointmentClients[index].date}',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'A: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bleu,
                              ),
                            ),
                            Text(
                              ' ${_appointmentClients[index].time}',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Motif: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bleu,
                              ),
                            ),
                            Text(
                              ' ${_appointmentClients[index].motif}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
