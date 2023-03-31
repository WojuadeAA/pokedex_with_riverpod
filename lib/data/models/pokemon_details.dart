import 'package:equatable/equatable.dart';

class PokemonDetails extends Equatable {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final List<String> types;
  final List<Stat> stats;
  final bool isFavorite;
  const PokemonDetails({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.isFavorite,
  });
  factory PokemonDetails.fromJsonRemote(
      Map<String, dynamic> json, bool isFavorite) {
    List<Stat> stats = [];
    List<String> types = [];
    final List<Map<String, dynamic>> resStat =
        List<Map<String, dynamic>>.from(json['stats']);
    final List<Map<String, dynamic>> resTypes =
        List<Map<String, dynamic>>.from(json['types']);
    stats = resStat
        .map(
          (stat) =>
              Stat(name: stat['stat']['name'], baseStat: stat['base_stat']),
        )
        .toList();
    types = resTypes.map((type) => type['type']['name'] as String).toList();

    return PokemonDetails(
        id: json['id'],
        name: json['name'],
        height: json['height'],
        weight: json['weight'],
        imageUrl: json['sprites']['other']['official-artwork']['front_default'],
        types: types,
        stats: stats,
        isFavorite: isFavorite);
  }

  factory PokemonDetails.fromJsonLocal(Map<String, dynamic> json) =>
      PokemonDetails(
        id: json["id"],
        name: json["name"],
        height: json["height"],
        weight: json["weight"],
        imageUrl: json["imageUrl"],
        types: List<String>.from(json["types"].map((x) => x)),
        stats: List<Stat>.from(json["stats"].map((x) => Stat.fromJson(x))),
        isFavorite: json["isFavorite"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "height": height,
        "weight": weight,
        "imageUrl": imageUrl,
        "types": types,
        "stats": List<dynamic>.from(stats.map((x) => x.toJson())),
        "isFavorite": isFavorite,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Stat {
  final String name;
  final int baseStat;
  Stat({required this.name, required this.baseStat});

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        name: json["name"],
        baseStat: json["base_stat"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "base_stat": baseStat,
      };
}

// {
    
//      "PokemonDetails":[
//   {
//     "id": 2,
//     "name": "name",
//     "height": "json",
//     "weight": "json['weight']",
//      "imageUrl": "json['sprites']['other']['official-artwork']['front_default']",
//     "types":" types",
//      "stats":" stats",
//     "isFavorite": "isFavorite"
     
// }
        
//          ]
// }
