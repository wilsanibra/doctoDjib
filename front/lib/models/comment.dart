class Comments {
  int? id;
  String? comment;
  String? name;
  String? date;
  String? image;
  int? id_doctor;
  int? user_id;

  Comments({
    this.id,
    this.comment,
    this.name,
    this.date,
    this.image,
    this.id_doctor,
    this.user_id,
  });
  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json["id"] as int,
      comment: json["comment"],
      name: json["name"],
      date: json["date"],
      image: json["image"],
      id_doctor: json["id_doctor"],
      user_id: json["user_id"],
    );
  }
}

class StoreComments {
  int? id;
  String? comment;
  String? date;
  String? id_doctor;

  StoreComments({
    this.id,
    this.comment,
    this.date,
    this.id_doctor,
  });
  factory StoreComments.fromJson(Map<String, dynamic> json) {
    return StoreComments(
      id: json['comment']["id"],
      comment: json['comment']["comment"],
      date: json['comment']["date"],
      id_doctor: json['comment']["id_doctor"],
    );
  }
}
