class Likes {
  int? countLikes;
  Likes({
    this.countLikes,
  });
  factory Likes.fromJson(Map<String, dynamic> json) {
    return Likes(countLikes: json["likes"]);
  }
}
