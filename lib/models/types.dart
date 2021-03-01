class Types {
  String name, url;
  int slot;

  Types({this.slot, this.name, this.url});

  factory Types.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> types = json['type'];
    return Types(slot: json['slot'], name: types['name'], url: types['url']);
  }
}
