import 'dart:convert';

import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';

// To parse this JSON data, do
//
//     final favoritePokemons = favoritePokemonsFromJson(jsonString);

FavoritePokemons favoritePokemonsFromJson(String str) =>
    FavoritePokemons.fromJson(json.decode(str));

String favoritePokemonsToJson(FavoritePokemons data) =>
    json.encode(data.toJson());

class FavoritePokemons {
  FavoritePokemons({
    required this.pokemons,
  });

  List<PokemonDetails> pokemons;

  factory FavoritePokemons.fromJson(Map<String, dynamic> json) =>
      FavoritePokemons(
        pokemons: List<PokemonDetails>.from(json["pokemon_details"]
            .map((x) => PokemonDetails.fromJsonLocal(x))),
      );

  Map<String, dynamic> toJson() => {
        "pokemon_details": List<dynamic>.from(pokemons.map((x) => x.toJson())),
      };
}
