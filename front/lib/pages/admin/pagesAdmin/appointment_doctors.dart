import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/services/appointment_service.dart';
import 'package:flutter/material.dart';

class appointmentDoctors extends StatefulWidget {
  const appointmentDoctors({super.key});

  @override
  State<appointmentDoctors> createState() => _appointmentDoctorsState();
}

class _appointmentDoctorsState extends State<appointmentDoctors> {
  List<dynamic> allAppointemntDoctors = [];
  bool _loading = true;
  void _getAppointmentsDoctors() async {
    ApiResponse response = await getAllApoinmentDocotors();
    if (response.error == null) {
      setState(() {
        allAppointemntDoctors = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getAppointmentsDoctors();
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
            itemCount: allAppointemntDoctors.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 5,
                  top: 3.5,
                ),
                child: Container(
                  height: 120,
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
                              'Dr: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bleu,
                              ),
                            ),
                            Text(
                              '${allAppointemntDoctors[index].name}',
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
                              '${allAppointemntDoctors[index].email} / ${allAppointemntDoctors[index].number}',
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
                              ' ${allAppointemntDoctors[index].specialty}',
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
                              ' ${allAppointemntDoctors[index].date}',
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
                              ' ${allAppointemntDoctors[index].time}',
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
