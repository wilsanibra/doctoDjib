import 'package:doctolib/constant.dart';
import 'package:doctolib/pages/accepte_appointment_client.dart';
import 'package:doctolib/pages/annule_appointment_client.dart';
import 'package:doctolib/pages/enattente_appointment_client.dart';
import 'package:flutter/material.dart';

class listeApointment extends StatefulWidget {
  const listeApointment({super.key});

  @override
  State<listeApointment> createState() => _listeApointmentState();
}

class _listeApointmentState extends State<listeApointment> {
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
      text: 'Annuler',
    ),
    const Tab(
      text: 'En attente',
    )
  ];

  final pages = <Widget>[
    const acceptAppointmentClient(),
    const annuleAppointmentClient(),
    const enattenteAppointmentClient(),
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
