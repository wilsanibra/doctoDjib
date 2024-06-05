import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/pages/doctor/fiche_page.dart';
import 'package:doctolib/services/doctor_service.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';

class listPatientsDoctors extends StatefulWidget {
  const listPatientsDoctors({super.key});

  @override
  State<listPatientsDoctors> createState() => _listPatientsDoctorsState();
}

class _listPatientsDoctorsState extends State<listPatientsDoctors> {
  List<dynamic> patients = [];
  bool _loading = true;
  String searchValue = '';
  String erreur = '';
  List<dynamic> searchPatient = [];
  void getPatientsAll() async {
    int idDoctor = await getUsrId();
    ApiResponse response = await getAllPatient(idDoctor);
    if (response.error == null) {
      setState(() {
        patients = response.data as List<dynamic>;
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

  void _seachPatient() async {
    if (searchValue != '') {
      ApiResponse response = await getPationsSearch(searchValue);
      if (response.error == null) {
        setState(() {
          searchPatient = response.data as List<dynamic>;
          _loading = _loading ? !_loading : _loading;
        });
      } else {
        erreur = response.error!;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPatientsAll();
    super.initState();
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
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(
        color: bleu,
      ));
    } else {
      return patients.isEmpty
          ? const Center(
              child: Text(
                "vous n'avez pas  du patient",
                style: TextStyle(
                  color: bleu,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: EasySearchBar(
                      backgroundColor: Colors.white,
                      title: const Text(
                        'Chercher par date(année-mois-jour)',
                        style: TextStyle(fontSize: 15),
                      ),
                      onSearch: (value) async {
                        setState(() {
                          searchValue = value;
                          _seachPatient();
                        });
                        // print(searchValue);
                      },
                      suggestions:
                          patients.map((p) => p.date.toString()).toList()),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  child: Text(
                    'Liste des Patients',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: bleu,
                      fontSize: 25,
                    ),
                  ),
                ),
                searchValue.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 2.5,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Container(
                                    width: 118,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      boxShadow: shadows,
                                      image: patients[index].image != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  '${patients[index].image}'),
                                              fit: BoxFit.cover)
                                          : const DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/man.png'),
                                              fit: BoxFit.cover),
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        color: bleu,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                      right: 1.5,
                                      bottom: 5,
                                      top: 3.5,
                                    ),
                                    child: Container(
                                      width: 250,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: shadows,
                                        border: Border.all(
                                          style: BorderStyle.solid,
                                          color: bleu,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                                  'Patient(e): ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: bleu,
                                                  ),
                                                ),
                                                Text(
                                                  '${patients[index].name}',
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'email: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: bleu,
                                                  ),
                                                ),
                                                Text(
                                                  //number
                                                  '${patients[index].email}',
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'numéro: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: bleu,
                                                  ),
                                                ),
                                                Text(
                                                  '${patients[index].number}',
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'adresse: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: bleu,
                                                  ),
                                                ),
                                                Text(
                                                  '${patients[index].address}',
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'date: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: bleu,
                                                  ),
                                                ),
                                                Text(
                                                  '${patients[index].date}',
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            InkWell(
                                              splashColor: bleu,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) => Fiche(
                                                      idPatient: patients[index]
                                                          .user_id,
                                                      namePatient:
                                                          patients[index].name,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                "voir sa fiche",
                                                style: TextStyle(
                                                  color: bleu,
                                                ),
                                              ),
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
                      )
                    : searchPatient.isNotEmpty
                        ? _loading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  itemCount: searchPatient.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: Container(
                                            width: 118,
                                            height: 118,
                                            decoration: BoxDecoration(
                                              boxShadow: shadows,
                                              image: searchPatient[index]
                                                          .image !=
                                                      null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          '${searchPatient[index].image}'),
                                                      fit: BoxFit.cover)
                                                  : const DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/man.png'),
                                                      fit: BoxFit.cover),
                                              border: Border.all(
                                                style: BorderStyle.solid,
                                                color: bleu,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 1.5,
                                              bottom: 5,
                                              top: 3.5,
                                            ),
                                            child: Container(
                                              width: 250,
                                              height: 118,
                                              decoration: BoxDecoration(
                                                boxShadow: shadows,
                                                border: Border.all(
                                                  style: BorderStyle.solid,
                                                  color: bleu,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
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
                                                          'Patient(e): ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: bleu,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${searchPatient[index].name}',
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'email: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: bleu,
                                                          ),
                                                        ),
                                                        Text(
                                                          //number
                                                          '${searchPatient[index].email}',
                                                          style:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'numéro: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: bleu,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${searchPatient[index].number}',
                                                          style:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'adresse: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: bleu,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${searchPatient[index].address}',
                                                          style:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'date: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: bleu,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${searchPatient[index].date}',
                                                          style:
                                                              const TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    InkWell(
                                                      splashColor: bleu,
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Fiche(
                                                              idPatient:
                                                                  patients[
                                                                          index]
                                                                      .user_id,
                                                              namePatient:
                                                                  patients[
                                                                          index]
                                                                      .name,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                        "voir sa fiche",
                                                        style: TextStyle(
                                                          color: bleu,
                                                        ),
                                                      ),
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
                              )
                        : const Text(
                            'pas de patient à cette date',
                            textAlign: TextAlign.center,
                          ),
              ],
            );
    }
  }
}
