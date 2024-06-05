import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/models/user.dart';
import 'package:doctolib/pages/accueil_page.dart';
import 'package:doctolib/pages/secretaire/accueil_secretaire.dart';
import 'package:doctolib/services/agenda_service.dart';
import 'package:doctolib/services/secretaire_service.dart';
import 'package:doctolib/widget/dropdownWidget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/appointment_service.dart';
import '../services/user_service.dart';
import 'login_page.dart';

import 'package:intl/intl.dart';

class Rdv extends StatefulWidget {
  final int? medecinId;
  final String? role;
  final String? nomSecretaire;
  const Rdv({
    super.key,
    this.medecinId,
    this.role,
    this.nomSecretaire,
  });

  @override
  State<Rdv> createState() => _RdvState();
}

class _RdvState extends State<Rdv> {
  late User users;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtMotif = TextEditingController();
  TextEditingController txtPatientRecord = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtAddress = TextEditingController(); // txtNumber
  TextEditingController txtNumber = TextEditingController(); // txtEmail
  TextEditingController txtEmail = TextEditingController(); //
  List<dynamic> _times = [];
  int? idAgendaDoctors = 0;
  String _radioval = '';
  bool loading = false;
  bool _loading = false;
  String selectedValue = "";
  DateTime today = DateTime.now();
  late String civil;
  // late String formattedDate = DateFormat('yyyy-MM-dd').format(today);
  late String formattedDate = DateFormat('dd-MM-yyyy').format(today);
  Future<DateTime> _onDaySelected(DateTime day, DateTime focusedDay) async {
    setState(
      () {
        today = day;
        // formattedDate = DateFormat('yyyy-MM-dd').format(today);
        formattedDate = DateFormat('dd-MM-yyyy').format(today);
        _getTime();
        _loading = true;
      },
    );
    return today;
  }

  void _storeAppointment() async {
    ApiResponse response = await storeAppointment(
      formattedDate,
      _radioval,
      txtMotif.text,
      widget.medecinId.toString(),
    );
    if (response.error == null) {
      _saveAppointmentAndReturnAccueil();
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _storeAppointmentSecretary() async {
    ApiResponse response = await storeAppointmentSecretary(
      txtName.text,
      txtAddress.text,
      txtNumber.text,
      txtEmail.text,
      '123456',
      'client',
      formattedDate,
      _radioval,
      txtMotif.text,
      widget.medecinId.toString(),
    );
    if (response.error == null) {
      _saveAppointmentAndReturnAccueil();
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _getTime() async {
    ApiResponse response = await getTimeDate(
      formattedDate.toString(),
      widget.medecinId.toString(),
    );
    if (response.error == null) {
      setState(() {
        _times = response.data as List<dynamic>;
        print('$_times');
        loading = loading ? !loading : loading;
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

  void _saveAppointmentAndReturnAccueil() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.info),
            SizedBox(
              width: 10,
            ),
            Text(
              'Information',
            ),
          ],
        ),
        content: const Text(
          'Votre rendez-vous est enrégistré avec succès',
        ),
        actions: [
          ElevatedButton.icon(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Colors.white,
              ),
            ),
            onPressed: () {
              widget.role == 'secrétaire' || widget.role == 'secretaire'
                  ? Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (content) => AccueilSecretaire(
                                nomsecretaire: widget.nomSecretaire,
                              )),
                      (route) => false,
                    )
                  : Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (content) => Accueil(nomClient: users.name)),
                      (route) => false,
                    );
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

  late CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bleu,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Docto-djib'.toUpperCase(),
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
      body: widget.role == 'secrétaire' || widget.role == 'secretaire'
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        DropDownWidget(
                          onValueChanged: (newValue) {
                            // Recevoir la valeur mise à jour du widget enfant
                            setState(() {
                              civil = newValue;
                              print("civil $civil");
                            });
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        TextFormField(
                          controller: txtName,
                          validator: (value) => value!.isEmpty
                              ? 'nom et prénom est invalides'
                              : null,
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
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        TextFormField(
                          controller: txtAddress,
                          validator: (value) => value!.isEmpty
                              ? 'Votre adresse est invalide'
                              : null,
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
                            labelText: 'Adresse',
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
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        TextFormField(
                          controller: txtNumber,
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.isEmpty
                              ? 'le numéro de téléphone invalide'
                              : null,
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
                            hintText: 'votre numéro de téléphone',
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
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        TextFormField(
                          controller: txtMotif,
                          validator: (val) =>
                              val!.isEmpty ? "veuillez remplir ce champ" : null,
                          decoration: const InputDecoration(
                            labelText: 'Motif',
                            labelStyle: TextStyle(
                              color: bleu,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        TextFormField(
                          controller: txtEmail,
                          validator: (value) =>
                              value!.isEmpty ? 'Email est invalide' : null,
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
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        TableCalendar(
                          calendarFormat: _calendarFormat,
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          locale: "fr_FR",
                          headerVisible: true,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          firstDay: DateTime.utc(
                            2010,
                            10,
                            16,
                          ),
                          lastDay: DateTime.utc(
                            2030,
                            3,
                            14,
                          ),
                          selectedDayPredicate: (day) => isSameDay(
                            day,
                            today,
                          ),
                          focusedDay: today,
                          onDaySelected: _onDaySelected,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        Text(
                          'Horaire Disponible'.toUpperCase(),
                          style: const TextStyle(
                            color: bleu,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width,
                          child: _loading == false
                              ? const Text(
                                  "Selectionner une date pour voir si le medecin est disponible",
                                  style: TextStyle(color: bleu),
                                )
                              : _times.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _times.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (loading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          idAgendaDoctors = _times[index].id;
                                          return Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Radio(
                                                    activeColor: bleu,
                                                    value: _times[index].time,
                                                    groupValue: _radioval,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _radioval =
                                                            value as String;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                      '${_times[index].time} à ${_times[index].endtime}'),
                                                ],
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    )
                                  : const Text(
                                      "ce medecin ne travail pas à cette date, choisir une autre date",
                                    ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 17,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                bleu,
                              ),
                            ),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                // updateAgneda(idAgendaDoctors!);
                                loading = true;
                                _storeAppointmentSecretary();
                              }
                            },
                            child: const Text(
                              'Rendez-vous',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 17,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Colors.grey,
                              ),
                            ),
                            child: const Text(
                              'Annuler',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: txtMotif,
                          validator: (val) =>
                              val!.isEmpty ? "veuillez remplir ce champ" : null,
                          decoration: const InputDecoration(
                            labelText: 'Motif',
                            labelStyle: TextStyle(
                              color: bleu,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        TableCalendar(
                          calendarFormat: _calendarFormat,
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          locale: "fr_FR",
                          headerVisible: true,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          firstDay: DateTime.utc(
                            2010,
                            10,
                            16,
                          ),
                          lastDay: DateTime.utc(
                            2030,
                            3,
                            14,
                          ),
                          selectedDayPredicate: (day) => isSameDay(
                            day,
                            today,
                          ),
                          focusedDay: today,
                          onDaySelected: _onDaySelected,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        Text(
                          'Horaire Disponible'.toUpperCase(),
                          style: const TextStyle(
                            color: bleu,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width,
                          child: _loading == false
                              ? const Text(
                                  "Selectionner une date pour voir si le medecin est disponible",
                                  style: TextStyle(color: bleu),
                                )
                              : _times.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _times.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (loading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          idAgendaDoctors = _times[index].id;
                                          return Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Radio(
                                                    activeColor: bleu,
                                                    value: _times[index].time,
                                                    groupValue: _radioval,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _radioval =
                                                            value as String;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                      '${_times[index].time} à ${_times[index].endtime}'),
                                                ],
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    )
                                  : const Text(
                                      "ce medecin ne travail pas à cette date, choisir une autre date",
                                    ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 17,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                bleu,
                              ),
                            ),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                // updateAgneda(idAgendaDoctors!);
                                loading = true;
                                _storeAppointment();
                              }
                            },
                            child: const Text(
                              'Rendez-vous',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 90,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 17,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Colors.grey,
                              ),
                            ),
                            child: const Text(
                              'Annuler',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
