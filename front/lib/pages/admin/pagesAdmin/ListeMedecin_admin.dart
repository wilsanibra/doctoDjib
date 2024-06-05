import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/pages/admin/pagesAdmin/detailsMedecin.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../../services/doctor_service.dart';

class ListeMedecinAdmin extends StatefulWidget {
  const ListeMedecinAdmin({super.key});

  @override
  State<ListeMedecinAdmin> createState() => _ListeMedecinAdminState();
}

class _ListeMedecinAdminState extends State<ListeMedecinAdmin> {
  int doctorId = 0;
  List<dynamic> _doctors = [];
  bool _loading = true;
  late String? role = '';
  Future<void> retrievePosts() async {
    ApiResponse response = await listeDoctors();
    role = await getRole();
    if (response.error == null) {
      setState(() {
        _doctors = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
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

  void _delete(int idUsers) async {
    ApiResponse response = await deleteUser(idUsers);
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
          retrievePosts();
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
    super.initState();
    retrievePosts();
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
        : ListView(
            children: [
              const SizedBox(
                child: Text(
                  'Liste des Medecins',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: bleu,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView.builder(
                  itemCount: _doctors.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Container(
                            width: 118,
                            height: 118,
                            decoration: BoxDecoration(
                              boxShadow: shadows,
                              image: _doctors[index].image != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          '${_doctors[index].image}'),
                                      fit: BoxFit.cover)
                                  : const DecorationImage(
                                      image:
                                          AssetImage('assets/images/man.png'),
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
                              height: 118,
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
                                          '${_doctors[index].name}',
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
                                          '${_doctors[index].email}',
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Spécialité: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: bleu,
                                          ),
                                        ),
                                        Text(
                                          ' ${_doctors[index].specialty}',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsMedecin(
                                                  usersId: _doctors[index].id,
                                                  role: role,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.person_2_rounded,
                                            color: bleu,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _loading
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        ' Dr ${_doctors[index].name}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 43, 89, 109),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      content: const Text(
                                                        'Voulez-vous supprimer vraiment ce Medecin ?',
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
                                                                color: Colors
                                                                    .black),
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
                                                            _delete(
                                                              _doctors[index]
                                                                  .id,
                                                            );
                                                            // Navigator.pop(context);
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          ),
                                                          label: const Text(
                                                            'Supprimer',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: bleu,
                                          ),
                                        ),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.center,
                                        //   children: [
                                        //     IconButton(
                                        //       onPressed: () {},
                                        //       icon: const Icon(
                                        //         Icons.favorite,
                                        //         color: bleu,
                                        //       ),
                                        //     ),
                                        //     const SizedBox(width: 4),
                                        //     const Text('1000'),
                                        //   ],
                                        // )
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
          );
  }
}
