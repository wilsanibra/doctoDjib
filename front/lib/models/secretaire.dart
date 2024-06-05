class Secretaire {
  int? id;
  String? name;
  String? email;
  String? number;
  String? address;
  String? image;
  String? token;
  String? specialityType;
  String? date;
  String? time;
  String? motif;
  String? status;
  String? id_doctor;

  Secretaire({
    this.id,
    this.name,
    this.email,
    this.number,
    this.address,
    this.image,
    this.token,
    this.specialityType,
    this.date,
    this.time,
    this.motif,
    this.status,
    this.id_doctor,
  });

  factory Secretaire.fromJson(Map<String, dynamic> json) {
    return Secretaire(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      number: json['user']['number'],
      address: json['user']['address'],
      image: json['user']['image'],
      specialityType: json['user']['specialityType'],
      token: json['token'],
      date: json['appointment']["date"],
      time: json['appointment']["time"],
      motif: json['appointment']["motif"],
      id_doctor: json['appointment']["id_doctor"],
      status: json['appointment']["status"],
    );
  }
}
