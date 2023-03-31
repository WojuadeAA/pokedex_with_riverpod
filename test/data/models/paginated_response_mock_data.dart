import 'package:pokedex_with_riverpod/data/models/paginated_response.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon.dart';

final List<Map<String, dynamic>> kListOfPokemons = [
  {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
  {"name": "bulbasaur2", "url": "https://pokeapi.co/api/v2/pokemon/2/"}
];

Map<String, dynamic> kPaginatedResponseJsonData = {
  "count": 1281,
  "next": "https://pokeapi.co/api/v2/pokemon?offset=22&limit=11",
  "previous": "https://pokeapi.co/api/v2/pokemon?offset=0&limit=11",
  "results": [
    {"name": "butterfree", "url": "https://pokeapi.co/api/v2/pokemon/12/"},
    {"name": "weedle", "url": "https://pokeapi.co/api/v2/pokemon/13/"},
    {"name": "kakuna", "url": "https://pokeapi.co/api/v2/pokemon/14/"},
    {"name": "beedrill", "url": "https://pokeapi.co/api/v2/pokemon/15/"},
    {"name": "pidgey", "url": "https://pokeapi.co/api/v2/pokemon/16/"},
    {"name": "pidgeotto", "url": "https://pokeapi.co/api/v2/pokemon/17/"},
    {"name": "pidgeot", "url": "https://pokeapi.co/api/v2/pokemon/18/"},
    {"name": "rattata", "url": "https://pokeapi.co/api/v2/pokemon/19/"},
    {"name": "raticate", "url": "https://pokeapi.co/api/v2/pokemon/20/"},
    {"name": "spearow", "url": "https://pokeapi.co/api/v2/pokemon/21/"},
    {"name": "fearow", "url": "https://pokeapi.co/api/v2/pokemon/22/"}
  ]
};
final PaginatedResponse kPaginatedResponseData =
    PaginatedResponse<Pokemon>.fromJson(kPaginatedResponseJsonData,
        results: List<Pokemon>.from(
            kListOfPokemons.map((x) => Pokemon.fromJson(x))));
