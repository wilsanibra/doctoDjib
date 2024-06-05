import 'package:doctolib/models/doctors.dart';
import 'package:doctolib/models/like.dart';
import 'package:doctolib/pages/admin/pagesAdmin/detailsMedecin.dart';
import 'package:doctolib/pages/rdv_page.dart';
import 'package:doctolib/services/lik_service.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../services/doctor_service.dart';
import '../services/user_service.dart';
import 'login_page.dart';

class ListeMedecin extends StatefulWidget {
  final String? nomSecretaire;
  const ListeMedecin({
    super.key,
    this.nomSecretaire,
  });

  @override
  State<ListeMedecin> createState() => _ListeMedecinState();
}

class _ListeMedecinState extends State<ListeMedecin> {
  List<dynamic> _doctors = [];
  int docId = 0;
  Likes? _countLikes;
  List<dynamic> doctorsSearch = [];
  bool _loading = true;
  bool liked = false;
  String searchValue = '';
  String erreur = '';
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

  void _getLikesnumber(int idDoctor) async {
    ApiResponse response = await getCountLikes(idDoctor);
    if (response.error == null) {
      setState(() {
        _countLikes = response.data as Likes;
      });
      // print('yes');
    } else {
      print('not ok');
    }
  }

  void _searchDoctors() async {
    print("ato ${searchValue}");
    if (searchValue.isNotEmpty) {
      ApiResponse response = await listeSearchDoctors(searchValue);
      if (response.error == null) {
        // print("atokoa");
        // setState(() {
        //   doctorsSearch = response.data as List<dynamic>;
        // });
      } else {
        print("not ok");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.white,
        //     content: Text(
        //       '${response.error}',
        //       style: const TextStyle(
        //         fontStyle: FontStyle.italic,
        //         color: Color.fromARGB(
        //           255,
        //           43,
        //           89,
        //           109,
        //         ),
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        // );
      }
    }
  }

  void likeOrUnlikeDoctors(int idDoctor) async {
    ApiResponse response = await likeUnlikeDoctors(idDoctor);
    if (response.error == null) {
      setState(() {
        retrievePosts();
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
          backgroundColor: Colors.white,
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
  // final List<String> _suggestions = _doctors
  //                       .map(
  //                         (e) => e.name.toString(),
  //                       )
  //                       .toList();
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: EasySearchBar(
                backgroundColor: Colors.white,
                title: const Text(
                  'Chercher par le nom complet',
                  style: TextStyle(fontSize: 15),
                ),
                onSearch: (value) {
                  setState(
                    () {
                      searchValue = value;
                      _searchDoctors();
                    },
                  );
                },
                suggestions:
                    _doctors.map((e) => e.specialty.toString()).toList()),
          ),
          const SizedBox(
            height: 10,
          ),
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
          searchValue.isEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  //return
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
                                              docId = _doctors[index].id;
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) => Rdv(
                                                        role: role,
                                                        medecinId:
                                                            _doctors[index]
                                                                .user_id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                    Icons.calendar_month,
                                                    color: bleu),
                                              ),
                                            ],
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
                )
              : doctorsSearch.isEmpty
                  ? const Text('')
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: doctorsSearch.length,
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
                                    image: doctorsSearch[index].image != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                '${doctorsSearch[index].image}'),
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
                                                '${doctorsSearch[index].name}',
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
                                                '${doctorsSearch[index].email}',
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
                                                ' ${doctorsSearch[index].specialty}',
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  docId =
                                                      doctorsSearch[index].id;
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsMedecin(
                                                        usersId:
                                                            doctorsSearch[index]
                                                                .id,
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Rdv(
                                                            role: role,
                                                            medecinId:
                                                                doctorsSearch[
                                                                        index]
                                                                    .user_id,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                        Icons.calendar_month,
                                                        color: bleu),
                                                  ),
                                                ],
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
      );
    }
  }
}
