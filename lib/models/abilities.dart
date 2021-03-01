class Ability {
  String name, url;
  bool is_hidden;
  int slot;

  Ability({this.name, this.url, this.is_hidden, this.slot});

  factory Ability.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> ability = json["ability"];

    return Ability(
        name: ability["name"],
        url: ability["url"],
        is_hidden: json["is_hidden"],
        slot: json["slot"]);
  }
}
