class Fiches {
  int? id;
  String? antecedent;
  String? prescription;
  int? userid;
  String? date;
  String? createdAt;
  Fiches({
    this.id,
    this.antecedent,
    this.prescription,
    this.date,
    this.createdAt,
    this.userid,
  });
  factory Fiches.fromJson(Map<String, dynamic> json) {
    //created_at
    return Fiches(
      id: json["id"],
      antecedent: json["antecedent"] as String,
      prescription: json["prescription"] as String,
      date: json["date"] as String,
      createdAt: json["created_at"] as String,
      userid: json["user_id"],
    );
  }
}

// class StoreFiches {
//   int? id;
//   String? antecedent;
//   String? prescription;
//   String? userid;
//   StoreFiches({
//     this.id,
//     this.antecedent,
//     this.prescription,
//     this.userid,
//   });
//   factory StoreFiches.fromJson(Map<String, dynamic> json) {
//     return StoreFiches(
//       id: json["fiches"]["id"],
//       antecedent: json["fiches"]["antecedent"],
//       prescription: json["fiches"]["prescription"],
//       userid: json["fiches"]["user_id"],
//     );
//   }
// }
