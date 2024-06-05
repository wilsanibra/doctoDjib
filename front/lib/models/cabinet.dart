class Cabinet {
  int? id;
  String? nomCab;
  Cabinet({
    this.id,
    this.nomCab,
  });
  factory Cabinet.fromJson(Map<String, dynamic> json) {
    return Cabinet(
      id: json['id'],
      nomCab: json['nomCab'],
    );
  }
}
