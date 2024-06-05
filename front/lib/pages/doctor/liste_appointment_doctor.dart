import 'package:doctolib/constant.dart';
import 'package:doctolib/pages/doctor/appointment_en_attend.dart';
import 'package:doctolib/pages/doctor/appointment_list.dart';
import 'package:flutter/material.dart';


class listeAppointmentDoctors extends StatefulWidget {
  const listeAppointmentDoctors({super.key});

  @override
  State<listeAppointmentDoctors> createState() =>
      _listeAppointmentDoctorsState();
}

class _listeAppointmentDoctorsState extends State<listeAppointmentDoctors> {
  final shadows = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ];

  final List<Tab> _ktabs = <Tab>[
    const Tab(
      text: 'Accepter',
    ),
    const Tab(
      text: 'En attente',
    )
  ];

  final pages = <Widget>[
    const listAppointment(),
    const appointmentAttente(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _ktabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Liste des rendez-vous',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: bleu,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: bleu,
            indicatorColor: bleu,
            tabs: _ktabs,
          ),
        ),
        body: TabBarView(
          children: pages,
        ),
      ),
    );
  }
}
