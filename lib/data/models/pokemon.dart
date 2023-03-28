class Pokemon {
  final String name;
  final String url;

  Pokemon(this.name, this.url);

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      Pokemon(json['name'], json['url']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['url'] = url;
    return map;
  }
}
