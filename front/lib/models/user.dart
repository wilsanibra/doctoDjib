class User {
  int? id;
  String? civility;
  String? name;
  String? email;
  String? number;
  String? address;
  // int? cabinet;
  String? image;
  String? token;
  String? specialityType;

  User({
    this.id,
    this.name,
    this.email,
    this.number,
    this.civility,
    this.token,
    this.address,
    // this.cabinet,
    this.image,
    this.specialityType,
  });

//funtction convertir json datato user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      civility: json['user']['civility'],
      name: json['user']['name'],
      email: json['user']['email'],
      number: json['user']['number'],
      address: json['user']['address'],
      // cabinet: json['user']['cabinet'],
      image: json['user']['image'],
      specialityType: json['user']['specialityType'],
      token: json['token'],
    );
  }
}

class Userdocto {
  int? id;
  String? name;
  String? email;
  String? number;
  String? address;
  String? image;
  String? token;
  int? cabinet;
  String? specialityType;

  Userdocto({
    this.id,
    this.name,
    this.email,
    this.number,
    this.token,
    this.address,
    this.cabinet,
    this.image,
    this.specialityType,
  });

//funtction convertir json datato user model
  factory Userdocto.fromJson(Map<String, dynamic> json) {
    return Userdocto(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      number: json['user']['number'],
      address: json['user']['address'],
      cabinet: json['user']['cabinet'],
      image: json['user']['image'],
      specialityType: json['user']['specialityType'],
      token: json['token'],
    );
  }
}

class ListUsers {
  int? id;
  String? name;
  String? email;
  String? number;
  String? address;
  String? image;
  String? specialityType;

  ListUsers({
    this.id,
    this.name,
    this.email,
    this.number,
    this.address,
    this.image,
    this.specialityType,
  });

  factory ListUsers.fromJson(Map<String, dynamic> json) {
    return ListUsers(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      number: json["number"],
      address: json["address"],
      image: json['image'],
      specialityType: json["specialty"],
    );
  }
}
