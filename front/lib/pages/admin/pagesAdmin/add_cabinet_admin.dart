import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/services/cabinet_service.dart';
import 'package:flutter/material.dart';

class addCabinetAdmin extends StatefulWidget {
  const addCabinetAdmin({super.key});

  @override
  State<addCabinetAdmin> createState() => _addCabinetAdminState();
}

class _addCabinetAdminState extends State<addCabinetAdmin> {
  final GlobalKey<FormState> _keyFormCabinet = GlobalKey<FormState>();

  TextEditingController txtCabinet = TextEditingController();
  List<dynamic> cabinets = [];
  final shadows = [
    BoxShadow(
      color: Colors.white70.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ];
  bool loading = true;

  // function to store Cabinet
  void _sotreCabinet() async {
    ApiResponse response = await storeCabinet(
      txtCabinet.text,
    );
    if (response.error == null) {
      setState(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.white,
              content: Text(
                'le cabinet est enrégistré avec succes',
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
          allCabinet();
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
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

// function to get All cabinet
  void allCabinet() async {
    ApiResponse response = await getAllCabinet();
    if (response.error == null) {
      setState(() {
        cabinets = response.data as List<dynamic>;
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

// function to delete cabinet
  void deleteCabinet(int idCabinet) async {
    ApiResponse response = await delete(idCabinet);
    if (response.error == null) {
      setState(
        () {
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
          allCabinet();
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
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allCabinet();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: ListView(
        children: [
          const Text(
            "Ajouter un cabinet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: bleu,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Form(
                key: _keyFormCabinet,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: txtCabinet,
                        validator: (val) =>
                            val!.isEmpty ? "veuillez remplir ce champ" : null,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            bleu,
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Ajouter'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white70.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (_keyFormCabinet.currentState!.validate()) {
                            setState(() {
                              loading = true;
                              _sotreCabinet();
                              txtCabinet.text = '';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            height: 20,
            color: bleu,
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Liste des Cabinets",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: bleu,
              fontSize: 20,
            ),
          ),
          loading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  child: ListView.builder(
                    itemCount: cabinets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: 250,
                          height: 50,
                          decoration: BoxDecoration(
                            boxShadow: shadows,
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: bleu,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${cabinets[index].nomCab}'),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        loading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: Text(
                                                    'Suppression du ${cabinets[index].nomCab}',
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 43, 89, 109),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  content: const Text(
                                                    'Voulez-vous supprimer vraiment ce Cabinet',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 43, 89, 109),
                                                    ),
                                                  ),
                                                  actions: [
                                                    ElevatedButton.icon(
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
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
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    ElevatedButton.icon(
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                          Colors.red,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        deleteCabinet(
                                                          cabinets[index].id,
                                                        );
                                                        // deleteAgenda(
                                                        //     _agendaDoctors[
                                                        //             index]
                                                        //         .id);
                                                        // Navigator.pop(context);
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
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
