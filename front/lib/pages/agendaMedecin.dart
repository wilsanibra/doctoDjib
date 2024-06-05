import 'package:date_time_picker/date_time_picker.dart';
import 'package:doctolib/constant.dart';
import 'package:doctolib/models/agenda.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/services/agenda_service.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class agendaMedecin extends StatefulWidget {
  const agendaMedecin({super.key});

  @override
  State<agendaMedecin> createState() => _agendaMedecinState();
}

class _agendaMedecinState extends State<agendaMedecin> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late TextEditingController ctrlDate = TextEditingController(text: dateAgenda);
  late TextEditingController ctrlStartTime =
      TextEditingController(text: timeAgenda);
  late TextEditingController ctrlEndTime =
      TextEditingController(text: timeAgenda);

  // final TextEditingController ctrlDate = TextEditingController();
  // final TextEditingController ctrlStartTime = TextEditingController();
  // final TextEditingController ctrlEndTime = TextEditingController();
  String _valueSaved3 = '';
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved4 = '';
  String _valueChanged4 = '';
  String _valueToValidate4 = '';
  String _valueSaved5 = '';
  String _valueChanged5 = '';
  String _valueToValidate5 = '';
  DateTime _datetimes = DateTime.now();
  late String dateAgenda = DateFormat('dd-MM-yyyy').format(_datetimes);
  late String timeAgenda = DateFormat('HH:mm').format(_datetimes);
  List<dynamic> _agendaDoctors = [];
  bool loading = true;
  final shadows = [
    BoxShadow(
      color: Colors.white70.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ];
  Future<void> _storAgendaDoct() async {
    int idDoctor = await getUsrId();
    ApiResponse response = await storeAgendaMedecin(
      _valueChanged3,
      _valueChanged4,
      _valueChanged5,
      // DateFormat('dd-MM-yyyy').format(_datetimes),
      // DateFormat('HH:mm').format(_datetimes),
      idDoctor.toString(),
    );
    if (response.error == null) {
      _saveAppointmentAndReturnAccueil(response.data as Agenda);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void printfunction() {
    print('Date controlleur');
    print('Date controlleur $_valueChanged3');
    // print('Start time controlleur ${ctrlStartTime.text}');
    // print('End time controlleur ${ctrlEndTime.text}');
  }

  void getAllagendaDoctor() async {
    int idDoctor = await getUsrId();
    ApiResponse response = await listAgendasDoctors(idDoctor);
    if (response.error == null) {
      setState(() {
        _agendaDoctors = response.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
    } else {}
  }

  void _saveAppointmentAndReturnAccueil(Agenda appointment) {
    setState(() {
      loading = loading ? !loading : loading;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'votre agenda est enrégistrer avec succès',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      getAllagendaDoctor();
      Navigator.pop(context);
    });
  }

  void deleteAgenda(int idAgenda) async {
    ApiResponse response = await deleteAgendaDoctors(idAgenda);
    if (response.error == null) {
      setState(
        () {
          loading = loading ? !loading : loading;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.white,
              content: Text(
                '${response.data}',
                style: const TextStyle(
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
          getAllagendaDoctor();
          Navigator.pop(context);
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
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    getAllagendaDoctor();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: ListView(
          children: [
            const Text(
              "Liste de vos agendas",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: bleu,
                fontSize: 20,
              ),
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: bleu,
                  ))
                : _agendaDoctors.isEmpty
                    ? const Center(
                        child: Text(
                          "Votre agenda est vide",
                          style: TextStyle(
                            color: bleu,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: ListView.builder(
                          itemCount: _agendaDoctors.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                width: 250,
                                height: 100,
                                decoration: BoxDecoration(
                                  boxShadow: shadows,
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    color: bleu,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: [
                                    // const SizedBox(
                                    //   height: 15,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                color: bleu,
                                              ),
                                              Text(
                                                  '${_agendaDoctors[index].date}'),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.timer,
                                                color: bleu,
                                              ),
                                              Text(
                                                  'début: ${_agendaDoctors[index].time}'),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.timer,
                                                color: bleu,
                                              ),
                                              Text(
                                                  'fin: ${_agendaDoctors[index].endtime}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                      child: Divider(
                                        indent: 10.0,
                                        endIndent: 10.0,
                                        color: bleu,
                                        height: 3,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          loading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text(
                                                      'Suppression',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 43, 89, 109),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    content: const Text(
                                                      'Voulez-vous supprimer vraiment cet agenda  ?',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 43, 89, 109),
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton.icon(
                                                        style:
                                                            const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                            Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.cancel,
                                                          color: Colors.black,
                                                        ),
                                                        label: const Text(
                                                          'Annuler',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      ElevatedButton.icon(
                                                        style:
                                                            const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                            Colors.red,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          deleteAgenda(
                                                              _agendaDoctors[
                                                                      index]
                                                                  .id);
                                                          // Navigator.pop(
                                                          //     context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                        label: const Text(
                                                          'Supprimer',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              'Supprimer',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        backgroundColor: bleu,
        onPressed: () {
          setState(
            () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.calendar_month,
                        color: bleu,
                      ),
                      Text(
                        'votre Agenda',
                        style: TextStyle(color: bleu),
                      ),
                    ],
                  ),
                  content: SizedBox(
                    height: 250,
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          DateTimePicker(
                            // controller: ctrlDate,
                            type: DateTimePickerType.date,
                            dateMask: 'd MMM, yyyy',
                            // initialValue: "DateTime.now().toString()",
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: const Icon(
                              Icons.event,
                              color: bleu,
                            ),
                            dateLabelText: 'Date',
                            selectableDayPredicate: (date) {
                              // Disable weekend days to select from the calendar
                              if (date.weekday == 6 || date.weekday == 7) {
                                return false;
                              }

                              return true;
                            },
                            onChanged: (val) =>
                                setState(() => _valueChanged3 = val),
                            validator: (val) {
                              setState(() => _valueToValidate3 = val ?? '');
                              if (_valueToValidate3.isEmpty) {
                                return 'Veuillez sélectionner une date.';
                              }
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _valueSaved3 = val ?? ''),
                          ),
                          DateTimePicker(
                            cursorColor: bleu,
                            type: DateTimePickerType.time,
                            locale: const Locale('fr', 'FR'),
                            //timePickerEntryModeInput: true,
                            // controller: ctrlStartTime,
                            initialValue: '', //_initialValue,
                            icon: const Icon(
                              Icons.access_time,
                              color: bleu,
                            ),
                            timeLabelText: "Heure de debut",
                            use24HourFormat: true,
                            onChanged: (val) =>
                                setState(() => _valueChanged4 = val),
                            validator: (val) {
                              setState(() => _valueToValidate4 = val ?? '');
                              if (_valueToValidate4.isEmpty) {
                                return 'Veuillez sélectionner une heure de debut.';
                              }
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _valueSaved4 = val ?? ''),
                          ),
                          DateTimePicker(
                            cursorColor: bleu,
                            type: DateTimePickerType.time,
                            //timePickerEntryModeInput: true,
                            // controller: ctrlEndTime,
                            initialValue: '', //_initialValue,
                            icon: const Icon(
                              Icons.access_time,
                              color: bleu,
                            ),
                            timeLabelText: "Heure de fin",
                            use24HourFormat: true,
                            locale: const Locale('fr', 'FR'),
                            onChanged: (val) =>
                                setState(() => _valueChanged5 = val),
                            validator: (val) {
                              setState(() => _valueToValidate5 = val ?? '');
                              if (_valueToValidate5.isEmpty) {
                                return 'Veuillez sélectionner une heure de fin.';
                              }
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _valueSaved5 = val ?? ''),
                          ),
                        ],
                      ),
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
                        // final loForm = formkey.currentState;

                        // if (loForm?.validate() == true) {
                        //   // loForm?.save();
                        // }
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            _storAgendaDoct();
                            // printfunction();
                            // _storeFiche();
                            // txtAntecedent.text = "";
                            // txtPrescription.text = "";
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Enregistrer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
          // final pickedDate = await showDatePicker(
          //   context: context,
          //   initialDate: _datetimes,
          //   firstDate: DateTime(1900),
          //   lastDate: DateTime(2100),
          // );
          // if (pickedDate != null) {
          //   final pickedTime = await showTimePicker(
          //     context: context,
          //     initialTime: TimeOfDay.fromDateTime(_datetimes),
          //   );
          //   if (pickedTime != null) {
          //     setState(() {
          //       _datetimes = DateTime(pickedDate.year, pickedDate.month,
          //           pickedDate.day, pickedTime.hour, pickedTime.minute);
          //       dateAgenda = DateFormat('dd-MM-yyyy').format(_datetimes);
          //       timeAgenda = DateFormat('HH:mm').format(_datetimes);
          //     });
          //   }
          // }
        },
        label: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.white70.withOpacity(0.7),
            ),
            Text(
              'Créer votre agenda',
              style: TextStyle(
                color: Colors.white70.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
