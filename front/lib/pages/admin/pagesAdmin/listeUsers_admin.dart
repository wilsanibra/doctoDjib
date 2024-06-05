import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/pages/admin/pagesAdmin/detailsMedecin.dart';
import 'package:flutter/material.dart';
import '../../../services/user_service.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({super.key});

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List<dynamic> allUser = [];
  bool _loading = true;
  late String? role = '';
  void _listeAllUsers() async {
    role = await getRole();
    ApiResponse response = await getAllUsers();
    if (response.error == null) {
      setState(() {
        allUser = response.data as List<dynamic>;
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
          _loading = _loading ? !_loading : _loading;
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
          _listeAllUsers();
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
    _listeAllUsers();
  }

  final shadows = [
    BoxShadow(
      color: Colors.white70.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                child: Text(
                  'Liste des utilisateurs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: bleu,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView.builder(
                  itemCount: allUser.length,
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
                              image: allUser[index].image != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          '${allUser[index].image}'),
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
                                          'M/Mme: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: bleu,
                                          ),
                                        ),
                                        Text(
                                          '${allUser[index].name}',
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
                                          '${allUser[index].email}',
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Rôle: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: bleu,
                                          ),
                                        ),
                                        Text(
                                          ' ${allUser[index].specialityType}',
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
                                                  usersId: allUser[index].id,
                                                  role: role,
                                                ),
                                              ),
                                            );
                                            // SharedPreferences pref =
                                            //     await SharedPreferences
                                            //         .getInstance();
                                            // await pref.setInt(
                                            //     'doctorId', allUser[index].id);
                                            // Navigator.push(
                                            //   context,
                                            //   PageRouteBuilder(
                                            //     pageBuilder: (_, __, ___) =>
                                            //         const DetailsMedecin(),
                                            //   ),
                                            // );
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
                                                        ' M/Mme ${allUser[index].name}',
                                                        style: const TextStyle(
                                                            color: bleu,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: const Text(
                                                        'Voulez-vous supprimer vraiment cette Utilisateur ?',
                                                        style: TextStyle(
                                                          color: bleu,
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
                                                              allUser[index].id,
                                                            );
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
                                        )
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
