class Specialities {
  int? id;
  String? specialty;
  int? user_id;

  Specialities({
    this.id,
    this.specialty,
    this.user_id,
  });
  factory Specialities.fromJson(Map<String, dynamic> json) {
    return Specialities(
      id: json['id'] as int,
      specialty: json['specialty'],
      user_id: json['user_id'],
    );
  }
}
