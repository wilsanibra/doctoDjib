class Agenda {
  int? id;
  String? date;
  String? time;
  String? endtime;
  String? status;
  int? id_doctor;

  Agenda({
    this.id,
    this.date,
    this.time,
    this.endtime,
    this.status,
    this.id_doctor,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json["id"],
      date: json["date"],
      time: json["time"],
      endtime: json["end_time"],
      status: json["status"],
      id_doctor: json["id_doctor"],
    );
  }
}
