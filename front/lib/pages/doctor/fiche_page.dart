import 'package:date_time_picker/date_time_picker.dart';
import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/services/fiche_service.dart';
import 'package:doctolib/services/user_service.dart';
/* import 'package:easy_search_bar/easy_search_bar.dart'; */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Fiche extends StatefulWidget {
  final int? idPatient;
  final String? namePatient;
  const Fiche({super.key, this.idPatient, this.namePatient});

  @override
  State<Fiche> createState() => _FicheState();
}

class _FicheState extends State<Fiche> {
  String _valueSaved3 = '';
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  bool _loading = true;
  List<dynamic> listfiches = [];
  List<dynamic> listfichesSearch = [];
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> formkey2 = GlobalKey<FormState>();
  TextEditingController txtAntecedent = TextEditingController();
  TextEditingController txtPrescription = TextEditingController();
  DateTime date = DateTime.now();
  late String dateFormat = DateFormat('yyyy-MM-dd').format(date);
  void _storeFiche() async {
    ApiResponse response = await storeFiche(
      txtAntecedent.text,
      txtPrescription.text,
      dateFormat,
      widget.idPatient.toString(),
    );
    if (response.error == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            '${response.data}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: bleu,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      getListFiche();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '${response.error}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void searchFiche() async {
    ApiResponse response = await getFichesSearch(_valueChanged3);
    if (response.error == null) {
      setState(() {
        listfichesSearch = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '${response.error}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void getListFiche() async {
    ApiResponse response = await getAllFiche(widget.idPatient as int);
    if (response.error == null) {
      setState(() {
        listfiches = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '${response.error}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void patient() {
    print("${widget.idPatient}");
    print("${widget.namePatient}");
  }

  @override
  void initState() {
    super.initState();
    patient();
    getListFiche();
  }

  final shadows = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.3),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ];
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
          'Fiche de ${widget.namePatient}',
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: bleu,
              ),
            )
          : ListView(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 1.5,
                  //return
                  child: listfiches.isEmpty
                      ? const Center(
                          child: Text(
                            'pas de fiche concernant à ce patient',
                            style: TextStyle(
                              color: bleu,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Form(
                              key: formkey2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: DateTimePicker(
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
                                        if (date.weekday == 6 ||
                                            date.weekday == 7) {
                                          return false;
                                        }

                                        return true;
                                      },
                                      onChanged: (val) =>
                                          setState(() => _valueChanged3 = val),
                                      validator: (val) {
                                        setState(() =>
                                            _valueToValidate3 = val ?? '');
                                        if (_valueToValidate3.isEmpty) {
                                          return 'Veuillez sélectionner une date.';
                                        }
                                        return null;
                                      },
                                      onSaved: (val) => setState(
                                          () => _valueSaved3 = val ?? ''),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (formkey2.currentState!.validate()) {
                                        setState(() {
                                          searchFiche();
                                          // _storAgendaDoct();
                                          // printfunction();
                                          // _storeFiche();
                                          // txtAntecedent.text = "";
                                          // txtPrescription.text = "";
                                        });
                                      }
                                    },
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                        Colors.grey,
                                      ),
                                    ),
                                    child: const Text(
                                      'Filtrer',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 500,
                              child: _valueChanged3.isEmpty
                                  ? ListView.builder(
                                      itemCount: listfiches.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5,
                                                  right: 5,
                                                  bottom: 5,
                                                  top: 3.5,
                                                ),
                                                child: Container(
                                                  width: 250,
                                                  // height: 118,
                                                  decoration: BoxDecoration(
                                                    boxShadow: shadows,
                                                    border: Border.all(
                                                      style: BorderStyle.solid,
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'Consultation du: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: bleu,
                                                              ),
                                                            ),
                                                            Text(
                                                              DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(DateTime.parse(
                                                                      listfiches[
                                                                              index]
                                                                          .createdAt)),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'Son antécédent: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: bleu,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${listfiches[index].antecedent}',
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Préscription: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: bleu,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${listfiches[index].prescription}',
                                                              style:
                                                                  const TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : listfichesSearch.isEmpty
                                      ? const Center(
                                          child: Text(
                                          'Aucun fiche patient',
                                          style: TextStyle(color: bleu),
                                        ))
                                      : ListView.builder(
                                          itemCount: listfichesSearch.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 5,
                                                      top: 3.5,
                                                    ),
                                                    child: Container(
                                                      width: 250,
                                                      // height: 118,
                                                      decoration: BoxDecoration(
                                                        boxShadow: shadows,
                                                        border: Border.all(
                                                          style:
                                                              BorderStyle.solid,
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  'Consultation du: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: bleu,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  DateFormat(
                                                                          'dd-MM-yyyy')
                                                                      .format(DateTime.parse(
                                                                          listfichesSearch[index]
                                                                              .createdAt)),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  'Son antécédent: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: bleu,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${listfichesSearch[index].antecedent}',
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  'Préscription: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: bleu,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${listfichesSearch[index].prescription}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                            ),
                          ],
                        ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bleu,
        onPressed: () {
          setState(
            () {
              showDialog(
                context: context,
                builder: (BuildContext context) => ListView(children: [
                  AlertDialog(
                    title: const Text("Ajouter une autre fiche"),
                    content: SingleChildScrollView(
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: txtAntecedent,
                              validator: (val) => val!.isEmpty
                                  ? "veuillez remplir ce champ"
                                  : null,
                              decoration: const InputDecoration(
                                labelText: 'Antécédent',
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
                              controller: txtPrescription,
                              validator: (val) => val!.isEmpty
                                  ? "veuillez remplir ce champ"
                                  : null,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                labelText: 'Préscription',
                                labelStyle: TextStyle(
                                  color: bleu,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: bleu,
                                  ),
                                ),
                              ),
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
                          'filtrer',
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
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              _storeFiche();
                              txtAntecedent.text = "";
                              txtPrescription.text = "";
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
                ]),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}