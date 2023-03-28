import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_with_riverpod/data/datasources/pokedex_remote_datasource.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';

import '../data/models/paginated_response.dart';
import '../data/models/pokemon.dart';

final paginatePokemonProvider =
    FutureProvider.family<PaginatedResponse<Pokemon>, int>(
        (ref, int page) async {
  final pokemonDataSource = ref.watch(pokemonRemoteDataSourceProvider);
  final offset = page * 11;
  return pokemonDataSource.getPokemons(offset);
});

final pokedexCountProvider = Provider<AsyncValue<int>>((ref) {
  return ref.watch(paginatePokemonProvider(0)).whenData(
        (PaginatedResponse<Pokemon> pageData) => pageData.totalResults,
      );
});
final currentPokemonPageProvider = Provider<AsyncValue<Pokemon>>((ref) {
  throw UnimplementedError();
});

final getPokemonDetailsProvider =
    FutureProvider.family<PokemonDetails, Pokemon>(
        (ref, Pokemon pokemon) async {
  final pokemonDataSource = ref.watch(pokemonRemoteDataSourceProvider);
  final pokemonDetails = await pokemonDataSource.getPokemonDetails(pokemon);
  return pokemonDetails;
});
