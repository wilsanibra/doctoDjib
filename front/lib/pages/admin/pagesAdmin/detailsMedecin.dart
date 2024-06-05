import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/services/comment_service.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../../models/user.dart';

class DetailsMedecin extends StatefulWidget {
  final int? usersId;
  final String? role;
  const DetailsMedecin({super.key, this.usersId, this.role});

  @override
  State<DetailsMedecin> createState() => _DetailsMedecinState();
}

class _DetailsMedecinState extends State<DetailsMedecin> {
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  TextEditingController txtComent = TextEditingController();
  bool loading = true;
  ListUsers? user;
  int userCurrent = 0;
  List<dynamic> comment = [];
  DateTime today = DateTime.now();

  void _getDoctorsDetails() async {
    ApiResponse response = await allUsersDetails(widget.usersId ?? 0);
    if (response.error == null) {
      setState(() {
        user = response.data as ListUsers;
        loading = loading ? !loading : loading;
      });
    } else {}
  }

  void _getComments() async {
    ApiResponse response = await listComments(widget.usersId ?? 0);
    userCurrent = await getUsrId();
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

  void _sendComments() async {
    ApiResponse response = await storeComments(
      txtComent.text,
      today.toString(),
      widget.usersId.toString(),
    );
    if (response.error == null) {
      setState(() {
        loading = loading ? !loading : loading;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'votre recommandation est crée avec succès',
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
        _getComments();
        Navigator.pop(context);
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

  void updateComments(int idComment) async {
    ApiResponse response = await updateCommentUsers(txtComent.text, idComment);
    if (response.error == null) {
      setState(() {
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
        _getComments();
        Navigator.pop(context);
      });
    }
  }

  void deletcomments(int idComments) async {
    ApiResponse response = await deleteComment(idComments);
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
          _getComments();
          // Navigator.pop(context);
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
    _getDoctorsDetails();
    _getComments();
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
        title: Text('Docto-djib'.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
            )
            // style: GoogleFonts.cinzel(
            //   color: Colors.white,
            // ),
            ),
        actions: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : showDialog(
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
                                    (value) => Navigator.of(context)
                                        .pushAndRemoveUntil(
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
      floatingActionButton: widget.role != 'client'
          ? null
          : FloatingActionButton(
              onPressed: () {
                txtComent.text = "";
                setState(
                  () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Form(
                        key: fromKey,
                        child: AlertDialog(
                          title: const Text(
                            'Recommandation',
                            style: TextStyle(
                              color: bleu,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: TextFormField(
                            controller: txtComent,
                            maxLines: 20,
                            decoration: const InputDecoration(
                              labelText: 'votre recommandantation',
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
                                  bleu,
                                ),
                              ),
                              onPressed: () {
                                _sendComments();
                              },
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Envoyer',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.send,
              ),
            ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
              ),
              child: ListView(
                children: [
                  Center(
                    child: GestureDetector(
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: user!.image != null
                                  ? DecorationImage(
                                      image: NetworkImage('${user!.image}'),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image:
                                          AssetImage('assets/images/man.png'),
                                      fit: BoxFit.cover,
                                    ),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: bleu,
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text('Nom: ${user!.name}'),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Contact: ${user!.email} / ${user!.number}',
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Son spécialité: ${user!.specialityType}',
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Recommandation:',
                                ),
                              ],
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
                                          borderRadius:
                                              BorderRadius.circular(250),
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
                                    widget.role == 'client' &&
                                            userCurrent ==
                                                comment[index].user_id
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 1.5,
                                                bottom: 5,
                                                top: 3.5,
                                              ),
                                              child: Container(
                                                width: 250,
                                                height: 90,
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
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: ListView(
                                                    children: [
                                                      Text(
                                                        '${comment[index].name} ',
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                            255,
                                                            43,
                                                            89,
                                                            109,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '"${comment[index].comment}"',
                                                        style: const TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '${comment[index].date}',
                                                            style:
                                                                const TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color
                                                                  .fromARGB(
                                                                255,
                                                                43,
                                                                89,
                                                                109,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(
                                                                () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        Form(
                                                                      key:
                                                                          fromKey,
                                                                      child:
                                                                          AlertDialog(
                                                                        title:
                                                                            const Text(
                                                                          'Modifier recommandation',
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                43,
                                                                                89,
                                                                                109),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        content:
                                                                            TextFormField(
                                                                          controller:
                                                                              txtComent,
                                                                          maxLines:
                                                                              20,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            labelText:
                                                                                'votre  recommandantation',
                                                                            labelStyle:
                                                                                TextStyle(
                                                                              color: bleu,
                                                                            ),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: bleu,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          ElevatedButton
                                                                              .icon(
                                                                            style:
                                                                                const ButtonStyle(
                                                                              backgroundColor: MaterialStatePropertyAll(
                                                                                Colors.white,
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.cancel,
                                                                              color: Colors.black,
                                                                            ),
                                                                            label:
                                                                                const Text(
                                                                              'Annuler',
                                                                              style: TextStyle(color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          ElevatedButton
                                                                              .icon(
                                                                            style:
                                                                                const ButtonStyle(
                                                                              backgroundColor: MaterialStatePropertyAll(
                                                                                bleu,
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              updateComments(comment[index].id);
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.send_rounded,
                                                                              color: Colors.white,
                                                                            ),
                                                                            label:
                                                                                const Text(
                                                                              'Modifier',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Modifier',
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                  255,
                                                                  43,
                                                                  89,
                                                                  109,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Text('|'),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              deletcomments(
                                                                comment[index]
                                                                    .id,
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Supprimer',
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                  255,
                                                                  43,
                                                                  89,
                                                                  109,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 1.5,
                                                bottom: 5,
                                                top: 3.5,
                                              ),
                                              child: Container(
                                                width: 250,
                                                height: 90,
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
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: ListView(
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '"${comment[index].comment}"',
                                                        style: const TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
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
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
