import 'package:doctolib/constant.dart';
import 'package:doctolib/pages/admin/pagesAdmin/appointment_client.dart';
import 'package:doctolib/pages/admin/pagesAdmin/appointment_doctors.dart';
import 'package:flutter/material.dart';

class ListeApointmentAdmin extends StatefulWidget {
  const ListeApointmentAdmin({super.key});

  @override
  State<ListeApointmentAdmin> createState() => _ListeApointmentAdminState();
}

class _ListeApointmentAdminState extends State<ListeApointmentAdmin> {
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
      text: 'Pour les médecins',
    ),
    const Tab(
      text: 'Pour les clients',
    )
  ];

  final pages = <Widget>[
    const appointmentDoctors(),
    const AppointementClients(),
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
