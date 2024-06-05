class Appointment {
  int? id;
  String? date;
  String? time;
  String? motif;
  // String? patient_record;
  String? status;
  String? id_doctor;

  Appointment({
    this.id,
    this.date,
    this.time,
    this.motif,
    // this.patient_record,
    this.status,
    this.id_doctor,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['appointment']["id"],
      date: json['appointment']["date"],
      time: json['appointment']["time"],
      motif: json['appointment']["motif"],
      // patient_record: json['appointment']["patient_record"],
      id_doctor: json['appointment']["id_doctor"],
      status: json['appointment']["status"],
    );
  }
}

class ListAppointment {
  int? id;
  String? name;
  String? date;
  String? time;
  String? email;
  String? address;
  String? number;
  String? specialty;
  String? motif;
  String? status;

  ListAppointment({
    this.id,
    this.name,
    this.date,
    this.time,
    this.email,
    this.address,
    this.number,
    this.specialty,
    this.motif,
    this.status,
  });

  factory ListAppointment.fromJson(Map<String, dynamic> json) {
    return ListAppointment(
      id: json["id"],
      name: json["names"],
      date: json["date"],
      time: json["times"],
      email: json["emails"],
      address: json["address"],
      number: json["number"],
      specialty: json["specialty"],
      motif: json["motif"],
      status: json["status"],
    );
  }
}

class ListAppointment2 {
  int? id;
  String? name;
  String? date;
  String? time;
  String? email;
  String? address;
  String? number;
  String? specialty;
  String? motif;
  String? checks;
  String? status;

  ListAppointment2({
    this.id,
    this.name,
    this.date,
    this.time,
    this.email,
    this.address,
    this.number,
    this.specialty,
    this.motif,
    this.status,
    this.checks,
  });

  factory ListAppointment2.fromJson(Map<String, dynamic> json) {
    return ListAppointment2(
      id: json["id"],
      name: json["name"],
      date: json["date"],
      time: json["time"],
      email: json["email"],
      address: json["address"],
      number: json["number"],
      specialty: json["specialty"],
      motif: json["motif"],
      status: json["status"],
      checks: json["checks"],
    );
  }
}
