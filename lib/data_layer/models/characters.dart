class Character {
  late int charId;
  late String name;
  late String nickName;
  late String image;
  late String statusDeadOrAlive;
  late List<dynamic> jobs;
  late List<dynamic> breakingBadSeasonsAppearance;
  late String categoryForTwoSeries;
  late List<dynamic> betterCallSaulSeasonsAppearance;
  late String actorName;

  Character.fromJson(Map<String, dynamic> json) {
    charId = json['char_id'];
    name = json['name'];
    nickName = json['nickname'];
    image = json['img'];
    statusDeadOrAlive = json['status'];
    jobs = json['occupation'];
    breakingBadSeasonsAppearance = json['appearance'];
    categoryForTwoSeries = json['category'];
    betterCallSaulSeasonsAppearance = json['better_call_saul_appearance'];
    actorName = json['portrayed'];
  }
}
