import 'package:date_time_picker/date_time_picker.dart';
import 'package:doctolib/constant.dart';
import 'package:doctolib/models/statistique.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:doctolib/widget/dropDownWidgetMonth.dart';
import 'package:doctolib/widget/dropDownWidgetYears.dart';
import 'package:doctolib/widget/dropdownWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/api_response.dart';
import '../../services/statistique_service.dart';

class Statistique extends StatefulWidget {
  String? nomdoctor;
  Statistique({super.key, this.nomdoctor});

  @override
  State<Statistique> createState() => _StatistiqueState();
}

class _StatistiqueState extends State<Statistique> {
  String _valueSaved3 = '';
  String? monthsNumbers;
  String? yearsNumber;
  String _valueChanged3 = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String _valueToValidate3 = '';
  Statistiques? _statistiquesSs;
  late List<dynamic> listStat;
  String? filtre = "";
  bool loading = true;
  int? dateBe;
  int? monsieur;
  int? madame;
  int? total;
  late List<DataRow> dataTableList = [];
  void test() {
    for (int i = 0; i < 10; i++) {
      dateBe = i++;
    }
  }

  void _getStat() async {
    int userId = await getUsrId();
    ApiResponse response = await getStat(userId);
    if (response.error == null) {
      setState(() {
        _statistiquesSs = response.data as Statistiques;
        listStat = _statistiquesSs!.lists!;
        monsieur = _statistiquesSs!.mr;
        madame = _statistiquesSs!.mde;
        total = _statistiquesSs!.count;
        dataTableList = listStat.map((l) {
          final splittedData = l.split(' ');
          return DataRow(
            cells: [
              DataCell(Text(splittedData[0])),
              DataCell(Text(splittedData[1])),
              DataCell(Text(splittedData[2])),
              DataCell(Text(splittedData[3])),
            ],
          );
        }).toList();
        loading = loading ? !loading : loading;
      });
    } else {
      print('${response.error}');
    }
  }

  void _getStatFiltrer() async {
    int userId = await getUsrId();
    String dateFilter;
    if (filtre == 'day') {
      dateFilter = _valueChanged3;
    } else if (filtre == 'month') {
      dateFilter = monthsNumbers!;
    } else {
      dateFilter = yearsNumber!;
    }
    ApiResponse response = await getStatFiltrer(
      userId,
      dateFilter,
      filtre!,
    );
    if (response.error == null) {
      setState(() {
        _statistiquesSs = response.data as Statistiques;
        listStat = _statistiquesSs!.lists!;
        monsieur = _statistiquesSs!.mr;
        madame = _statistiquesSs!.mde;
        total = _statistiquesSs!.count;
        dataTableList = listStat.map((l) {
          final splittedData = l.split(' ');
          return DataRow(
            cells: [
              DataCell(Text(splittedData[0])),
              DataCell(Text(splittedData[1])),
              DataCell(Text(splittedData[2])),
              DataCell(Text(splittedData[3])),
            ],
          );
        }).toList();
        loading = loading ? !loading : loading;
      });
    } else {
      print("${response.error}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStat();
    test();
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
          'Docteur ${widget.nomdoctor}'.toUpperCase(),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.white,
                                content: Text(
                                  'vous êtes déconnectés avec succès',
                                  style: TextStyle(
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: bleu,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Vos Statistiques',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: bleu,
                        fontSize: 25,
                      ),
                    ),
                    Row(
                      children: [
                        const Flexible(
                          flex: 1,
                          child: Text("Filtrer par : "),
                        ),
                        Flexible(
                          flex: 3,
                          child: DropDownWidget(
                            inDesign: false,
                            onValueChanged: (NewValues) {
                              setState(() {
                                filtre = NewValues;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    filtre == "day"
                        ? Row(
                            children: [
                              const Flexible(
                                flex: 1,
                                child: Text("date"),
                              ),
                              Flexible(
                                flex: 3,
                                child: DateTimePicker(
                                  // controller: ctrlDate,
                                  type: DateTimePickerType.date,
                                  dateMask: 'yyyy, d MMM',
                                  initialValue: "DateTime.now().toString()",
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  icon: const Icon(
                                    Icons.event,
                                    color: bleu,
                                  ),
                                  dateLabelText: 'Date',
                                  onChanged: (val) =>
                                      setState(() => _valueChanged3 = val),
                                  validator: (val) {
                                    setState(
                                        () => _valueToValidate3 = val ?? '');
                                    if (_valueToValidate3.isEmpty) {
                                      return 'Veuillez sélectionner une date.';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) =>
                                      setState(() => _valueSaved3 = val ?? ''),
                                ),
                              ),
                            ],
                          )
                        : filtre == "month"
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Flexible(
                                        flex: 1,
                                        child: Text("mois : "),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: DropDownWidgetMonths(
                                          onValueChanged: (NewValues) {
                                            setState(() {
                                              monthsNumbers = NewValues;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : filtre == "year"
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Flexible(
                                            flex: 1,
                                            child: Text("année : "),
                                          ),
                                          Flexible(
                                            flex: 3,
                                            child: DropDownWidgetYears(
                                              onValueChanged: (NewValues) {
                                                setState(() {
                                                  yearsNumber = NewValues;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                    filtre == "" || _valueChanged3 == ""
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              _getStatFiltrer();
                            },
                            child: const Text("Flitrer"),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Nombre des Masculins: "),
                        Text("$monsieur"),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Nombre des Feminins:  "),
                        Text("$madame"),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Total des patients: "),
                        Text("$total"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      shadowColor: const Color.fromARGB(66, 89, 85, 85),
                      elevation: 8,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          sortAscending: true,
                          headingTextStyle: const TextStyle(
                            color: bleu,
                            fontWeight: FontWeight.bold,
                          ),
                          columns: const [
                            DataColumn(label: Text('Genre')),
                            DataColumn(label: Text('Nom')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Heure')),
                          ],
                          rows: dataTableList,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
