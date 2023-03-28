import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_with_riverpod/data/datasources/pokedex_local_datasource.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';

final addToFavoriteProvider = ChangeNotifierProvider((ref) {
  return AddToFavorite(ref);
});

class AddToFavorite with ChangeNotifier {
  final Ref ref;

  AddToFavorite(this.ref);

  Future addPokemonToFavorite(PokemonDetails pokemon) async {
    final localFavoritePokemonDataSource =
        ref.watch(localFavoritePokemonDataSourceProvider);

    return localFavoritePokemonDataSource.addFavorite(pokemon);
  }

  Future removePokemonAsFavorite(PokemonDetails pokemon) async {
    final localFavoritePokemonDataSource =
        ref.watch(localFavoritePokemonDataSourceProvider);
    return localFavoritePokemonDataSource.removeAsFavorite(pokemon);
  }
}

final fetchFavoritePokemonsProvider = FutureProvider((ref) {
  final localFavoritePokemonDataSource =
      ref.watch(localFavoritePokemonDataSourceProvider);
  return localFavoritePokemonDataSource.fetchFavoritePokemons();
});

final favoritePokemonsCountProvider = Provider((ref) {
  final favoritePokemons = ref.watch(fetchFavoritePokemonsProvider);
  return favoritePokemons.whenData((value) => value.length);
});

final isFavoritePokemonProvider =
    Provider.family<AsyncValue<bool>, PokemonDetails>(
  (ref, pokemon) {
    final favoritePokemons = ref.watch(fetchFavoritePokemonsProvider);
    return favoritePokemons
        .whenData((value) => value.any((element) => element.id == pokemon.id));
  },
);
