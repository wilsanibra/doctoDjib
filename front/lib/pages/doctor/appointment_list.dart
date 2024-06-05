import 'package:doctolib/constant.dart';
import 'package:doctolib/models/api_response.dart';
import 'package:doctolib/pages/login_page.dart';
import 'package:doctolib/services/agenda_service.dart';
import 'package:doctolib/services/appointment_service.dart';
import 'package:doctolib/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';

class listAppointment extends StatefulWidget {
  const listAppointment({super.key});

  @override
  State<listAppointment> createState() => _listAppointmentState();
}

List<TimePlannerTask> tasks = [
  TimePlannerTask(
    // background color for task
    color: Colors.purple,
    // day: Index of header, hour: Task will be begin at this hour
    // minutes: Task will be begin at this minutes
    dateTime: TimePlannerDateTime(day: 0, hour: 14, minutes: 30),
    // Minutes duration of task
    minutesDuration: 90,
    // Days duration of task (use for multi days task)
    daysDuration: 1,
    onTap: () {},
    child: Text(
      'this is a task',
      style: TextStyle(color: Colors.grey[350], fontSize: 12),
    ),
  ),
];

class _listAppointmentState extends State<listAppointment> {
  List<dynamic> _agendaDoctors = [];
  List<dynamic> index = [];
  List<DateTime> times = [];

  List<int>? heure2;
  List<TimePlannerTask> tasks2 = [];
  List<dynamic> apointmentsClients = [];
  List<TimePlannerTitle> _headers2 = [];
  bool _loading = true;
  void getAllagendaDoctor() async {
    int idDoctor = await getUsrId();
    ApiResponse response = await listAgendasDoctors(idDoctor);
    if (response.error == null) {
      setState(() {
        _agendaDoctors = response.data as List<dynamic>;

        _loading = _loading ? !_loading : _loading;
      });
    } else {}
  }

  void _listeApointment() async {
    int userId = await getUsrId();
    ApiResponse response = await getAppoitmentsClientForDoctors(userId);
    if (response.error == null) {
      setState(() {
        apointmentsClients = response.data as List<dynamic>;
        apointmentsClients.map((headerJson) {
          String dateString = headerJson
              .date; // Supposons que headerJson.date est une chaîne de caractères représentant la date
          DateTime date = DateFormat('dd-MM-yyyy').parse(dateString);
          String formattedDate = DateFormat('EEEE', 'fr_FR').format(date);
          // DateTime date = DateFormat('dd-MM-yyyy').parse(headerJson.date);
          print('ato : $formattedDate');
        }).toList();
        _headers2 = apointmentsClients
            .map((headerJson) => TimePlannerTitle(
                  date: headerJson.date.toString(),
                  // title: "tst",
                  title: DateFormat('EEEE', 'fr_FR')
                      .format(DateFormat('dd-MM-yyyy').parse(headerJson.date)),
                ))
            .toList();
        //
        // tasks2 = apointmentsClients.map((taskDoc) {
        //   TimePlannerDateTime varessai =
        //       TimePlannerDateTime(day: 0, hour: 14, minutes: 30);
        //   int hours = 0;
        //   int minutes = 0;
        //   List<String> nom = taskDoc.name.split(",");
        //   taskDoc.time.split(",").map(
        //     (time) {
        //       hours = DateTime.parse(taskDoc.date + " " + time).hour;
        //       minutes = DateTime.parse(taskDoc.date + " " + time).minute;
        //       varessai = TimePlannerDateTime(
        //         day: apointmentsClients.indexOf(taskDoc),
        //         hour: hours,
        //         minutes: minutes,
        //       );
        //       // print('${varessai}');
        //     },
        //   ).toList();
        //   // print('${hours}');
        //   // print('${hours}');
        //   return TimePlannerTask(
        //     color: taskDoc.status == 'Annuler' || taskDoc.status == 'En attente'
        //         ? Colors.grey
        //         : bleu,
        //     // day: Index of header, hour: Task will be begin at this hour
        //     // minutes: Task will be begin at this minutes
        //     // dateTime: TimePlannerDateTime(
        //     //   day: apointmentsClients.indexOf(taskDoc),
        //     //   // day: apointmentsClients.indexOf(taskDoc),
        //     //   // day: DateTime.parse(taskDoc.date).day - 1,
        //     //   hour: hours,
        //     //   minutes: minutes,
        //     // ),
        //     dateTime: varessai,
        //     // Minutes duration of task
        //     minutesDuration: 90,
        //     // Days duration of task (use for multi days task)
        //     daysDuration: 1,
        //     onTap: () {},
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 5),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             'Mr/Mme: $nom',
        //             style: const TextStyle(
        //               color: Colors.white,
        //             ),
        //           ),
        //           Text(
        //             'Motif: ${taskDoc.motif}',
        //             style: const TextStyle(color: Colors.white, fontSize: 12),
        //           ),
        //           Text(
        //             'Adresse ${taskDoc.address}',
        //             style: const TextStyle(color: Colors.white, fontSize: 12),
        //           ),
        //           Text(
        //             'Email: ${taskDoc.email}',
        //             style: const TextStyle(color: Colors.white, fontSize: 12),
        //           ),
        //           Text(
        //             'Status: ${taskDoc.status}',
        //             style: const TextStyle(color: Colors.white, fontSize: 12),
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }).toList();
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
              color: Colors.white,
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
    _listeApointment();
    getAllagendaDoctor();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: CircularProgressIndicator(
              color: bleu,
            ),
          )
        : _headers2.isEmpty
            ? const Center(
                child: Text(
                  "vous n'avez pas de rendez-vous",
                  style: TextStyle(
                    color: bleu,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : TimePlanner(
                currentTimeAnimation: false,
                style: TimePlannerStyle(
                  // backgroundColor: Colors.blueGrey[900],
                  // default value for height is 80
                  // default value for width is 90
                  cellWidth: 150,
                  dividerColor: Colors.white,
                  showScrollBar: true,
                  horizontalTaskPadding: 2,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                // time will be start at this hour on table
                startHour: 6,
                // time will be end at this hour on table
                endHour: 23,
                // each header is a column and a day
                headers: _headers2,
                // List of task will be show on the time planner
                tasks: apointmentsClients.map((taskDoc) {
                  int hours = 0;
                  int minutes = 0;
                  taskDoc.time.split(",").map(
                    (time) {
                      hours = DateFormat('dd-MM-yyyy HH:mm')
                          .parse(taskDoc.date + " " + time)
                          .hour;
                      minutes = DateFormat('dd-MM-yyyy HH:mm')
                          .parse(taskDoc.date + " " + time)
                          .minute;
                      // varessai =
                      // print('${varessai}');
                    },
                  ).toList();
                  return TimePlannerTask(
                    color: taskDoc.status == 'Annuler' ||
                            taskDoc.status == 'En attente'
                        ? Colors.grey
                        : bleu,

                    dateTime: TimePlannerDateTime(
                      day: apointmentsClients.indexOf(taskDoc),
                      hour: hours,
                      minutes: minutes,
                    ),
                    // Minutes duration of task
                    minutesDuration: 40,
                    // Days duration of task (use for multi days task)
                    daysDuration: 1,
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mrs/Mmes: ${taskDoc.name}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
  }
}
