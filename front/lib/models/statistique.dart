class Statistiques {
  List<dynamic>? lists;
  int? mr;
  int? mde;
  int? count;

  Statistiques({
    this.lists,
    this.mr,
    this.mde,
    this.count,
  });
  factory Statistiques.fromJson(Map<String, dynamic> json) {
    return Statistiques(
      lists: json['lists'],
      mr: json['mr'],
      mde: json['mde'],
      count: json['count'],
    );
  }
}
