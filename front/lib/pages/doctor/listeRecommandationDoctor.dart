import 'package:doctolib/constant.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../models/api_response.dart';
import '../../services/comment_service.dart';

class listRecommandationDoctors extends StatefulWidget {
  const listRecommandationDoctors({super.key});

  @override
  State<listRecommandationDoctors> createState() =>
      _listRecommandationDoctorsState();
}

class _listRecommandationDoctorsState extends State<listRecommandationDoctors> {
  List<dynamic> comment = [];
  bool loading = true;
  void _getComments() async {
    int userCurrent = await getUsrId();
    ApiResponse response = await listComments(userCurrent);
    if (response.error == null) {
      setState(
        () {
          comment = response.data as List<dynamic>;
          loading = loading ? !loading : loading;
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

  final shadows = [
    BoxShadow(
      color: Colors.white70.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ];
  @override
  void initState() {
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return comment.isEmpty
        ? const Center(
            child: Text(
              "pas de recommandation",
              style: TextStyle(
                color: bleu,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView(
            children: [
              const SizedBox(
                child: Text(
                  'Vos recommandations',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: bleu,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: comment.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 2.0,
                            top: 4,
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(250),
                              image: comment[index].image != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        '${comment[index].image}',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                        'assets/images/man.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: const Color.fromARGB(
                                  255,
                                  43,
                                  89,
                                  109,
                                ),
                              ),
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
                              height: 80,
                              decoration: BoxDecoration(
                                boxShadow: shadows,
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: const Color.fromARGB(
                                    255,
                                    43,
                                    89,
                                    109,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListView(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${comment[index].name}',
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              43,
                                              89,
                                              109,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${comment[index].date}',
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '"${comment[index].comment}"',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
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
              ),
            ],
          );
  }
}
