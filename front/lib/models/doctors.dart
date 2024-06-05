

class Doctors {
  int? id;
  String? name;
  String? address;
  String? number;
  String? email;
  String? image;
  String? date;
  String? specialty;
  int? user_id;
  // Likes? likesCount;

  Doctors({
    this.id,
    this.name,
    this.address,
    this.number,
    this.email,
    this.image,
    this.specialty,
    this.date,
    // this.likesCount,
    this.user_id,
  });

  factory Doctors.fromJson(Map<String, dynamic> json) {
    return Doctors(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      number: json["number"],
      email: json["email"],
      image: json["image"],
      specialty: json["specialty"],
      date: json["date"],
      user_id: json["user_id"],
    );
  }
}

class DoctorsSearch {
  int? id;
  String? name;
  String? address;
  String? number;
  String? email;
  String? image;
  String? specialty;
  // int? likesCount;
  // bool? selLiked;
  int? user_id;

  DoctorsSearch({
    this.id,
    this.name,
    this.address,
    this.number,
    this.email,
    this.image,
    this.specialty,
    this.user_id,
  });

  factory DoctorsSearch.fromJson(Map<String, dynamic> json) {
    return DoctorsSearch(
      id: json["doctors"]["id"] as int,
      name: json["doctors"]["name"],
      address: json["doctors"]["address"],
      number: json["doctors"]["number"],
      email: json["doctors"]["email"],
      image: json["doctors"]["image"],
      specialty: json["doctors"]["specialty"],
      user_id: json["doctors"]["user_id"],
    );
  }
}
