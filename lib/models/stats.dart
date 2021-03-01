class Stats {
  int base_stat, effort;
  String name, url;

  Stats({this.base_stat, this.effort, this.name, this.url});

  factory Stats.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> stat = json['stats'];
    return Stats(
        base_stat: json['base_stat'],
        effort: json["effort"],
        name: stat['name'],
        url: stat['url']);
  }
}
